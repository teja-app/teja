import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';
import 'package:uuid/uuid.dart';
import 'package:teja/infrastructure/api/ai_question_api.dart';
import 'package:teja/presentation/journal/journal_editor/ui/typing_indicator.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';

class JournalEntryPage extends StatefulWidget {
  final List<Map<String, String>> initialQAList;

  const JournalEntryPage({super.key, required this.initialQAList});

  @override
  JournalEntryPageState createState() => JournalEntryPageState();
}

class JournalEntryPageState extends State<JournalEntryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  late List<Map<String, String>> qaList;

  final TextEditingController _textController = TextEditingController();
  late int currentQuestionIndex;
  bool showingAlternatives = false;
  List<String> _alternativeQuestions = [];
  late final Store<AppState> _store;
  final Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();
    qaList = List.from(widget.initialQAList);
    currentQuestionIndex = qaList.length - 1;
    _textController.addListener(_scrollToBottom);
    _store = StoreProvider.of<AppState>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processInitialAnswer();
    });
  }

  Future<void> _processInitialAnswer() async {
    if (qaList.isNotEmpty && qaList.last['answer']!.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _goDeeper(useExistingAnswer: true);
      } catch (e) {
        logger.e("JournalEntryPageState:_processInitialAnswer", error: e);
        _showError('Failed to generate new question: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  Future<void> _saveAndExit() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await saveAnswer(); // Save the current answer before exiting
      final journalEntry = _store.state.journalDetailState.selectedJournalEntry;
      await Future.delayed(const Duration(milliseconds: 100));
      await _store.dispatch(LoadJournalDetailAction(journalEntry!.id));
      // Navigate back to the previous screen (likely the journal detail page)
      await Future.delayed(const Duration(milliseconds: 100));
      _navigateToDetailPage(context, journalEntry!.id);
    } catch (e) {
      logger.e("JournalEntryPageState:_saveAndExit", error: e);
      _showError('Failed to save answer: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _navigateToDetailPage(BuildContext context, String entryId) {
    GoRouter.of(context).pushNamed(
      RootPath.journalDetail,
      queryParameters: {"id": entryId},
    );
  }

  Future<void> saveAnswer() async {
    if (_textController.text.isNotEmpty) {
      qaList[currentQuestionIndex]['answer'] = _textController.text;
      final journalEntry = _store.state.journalDetailState.selectedJournalEntry;
      if (journalEntry != null) {
        await _store.dispatch(UpdateQuestionAnswer(
          journalEntryId: journalEntry.id,
          questionId: qaList[currentQuestionIndex]['questionId'] ?? uuid.v4(),
          answerText: _textController.text,
          questionText: qaList[currentQuestionIndex]['question']!,
        ));
      }
      _textController.clear();
    }
  }

  Future<void> _goDeeper({bool useExistingAnswer = false}) async {
    if (!useExistingAnswer) {
      await saveAnswer();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final deeperQuestionResponse = await AIQuestionAPI().generateDeeperQuestion(
        QAData(qaList: qaList),
      );

      setState(() {
        qaList.add({
          'question': deeperQuestionResponse['question'],
          'answer': '',
          'questionId': uuid.v4(),
        });
        currentQuestionIndex++;
        showingAlternatives = false;
      });
    } catch (e) {
      logger.e("JournalEntryPageState:_goDeeper", error: e);
      _showError('Failed to generate new question: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _showAlternatives() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final alternativeQuestionsResponse = await AIQuestionAPI().generateAlternativeQuestions(
        QAData(qaList: qaList),
      );

      setState(() {
        _alternativeQuestions =
            (alternativeQuestionsResponse['alternatives'] as List<dynamic>).map((alt) => alt.toString()).toList();
        showingAlternatives = true;
      });
    } catch (e) {
      logger.e("JournalEntryPageState:_showAlternatives", error: e);
      _showError('Failed to generate alternative questions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _regenerateAlternatives() {
    setState(() {
      // In a real app, this would call the AI to generate new alternatives
      showingAlternatives = true;
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_scrollToBottom);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _backToWriting() {
    setState(() {
      showingAlternatives = false;
    });
  }

  void _selectAlternative(String question) {
    setState(() {
      qaList[currentQuestionIndex]['question'] = question;
      showingAlternatives = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSaving ? null : _saveAndExit,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: _isSaving ? null : _saveAndExit,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: qaList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            qaList[index]['question']!,
                            style: textTheme.titleSmall,
                          ),
                          if (index == currentQuestionIndex && !showingAlternatives && !_isLoading)
                            IconButton(
                              icon: const Icon(AntDesign.sync, size: 20),
                              onPressed: _showAlternatives,
                              tooltip: 'Show alternative questions',
                            ),
                          Text(
                            qaList[index]['answer']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (index == currentQuestionIndex && !showingAlternatives) ...[
                            if (_isLoading) const TypingIndicator(),
                            if (!_isLoading)
                              TextField(
                                controller: _textController,
                                decoration: const InputDecoration(
                                  hintText: 'Write...',
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                if (!showingAlternatives && !_isLoading) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Button(
                            text: "Continue",
                            icon: Icons.arrow_downward,
                            onPressed: () {
                              _goDeeper(useExistingAnswer: false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (showingAlternatives) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose a different question to explore:',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ..._alternativeQuestions
                            .map((question) => GestureDetector(
                                  onTap: () => _selectAlternative(question),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(question, style: textTheme.titleSmall),
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Regenerate'),
                            onPressed: _regenerateAlternatives,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _backToWriting,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Back to writing'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_errorMessage != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
