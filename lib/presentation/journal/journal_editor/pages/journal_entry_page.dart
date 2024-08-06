import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/infrastructure/api/ai_question_api.dart';
import 'package:teja/presentation/journal/journal_editor/ui/typing_indicator.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:uuid/uuid.dart';

class LoadingState {
  final bool isInitialLoading;
  final bool isGeneratingQuestion;
  final bool isSaving;

  const LoadingState({
    this.isInitialLoading = false,
    this.isGeneratingQuestion = false,
    this.isSaving = false,
  });

  LoadingState copyWith({
    bool? isInitialLoading,
    bool? isGeneratingQuestion,
    bool? isSaving,
  }) {
    return LoadingState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isGeneratingQuestion: isGeneratingQuestion ?? this.isGeneratingQuestion,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class JournalEntryPage extends StatefulWidget {
  final String journalEntryId;

  const JournalEntryPage({super.key, required this.journalEntryId});

  @override
  JournalEntryPageState createState() => JournalEntryPageState();
}

class JournalEntryPageState extends State<JournalEntryPage> {
  final ScrollController _scrollController = ScrollController();
  LoadingState _loadingState = LoadingState();
  String? _errorMessage;
  List<Map<String, String>> qaList = [];

  final TextEditingController _textController = TextEditingController();
  late int currentQuestionIndex;
  bool showingAlternatives = false;
  List<String> _alternativeQuestions = [];
  late final Store<AppState> _store;
  final Uuid uuid = Uuid();
  String? _helpText;
  List<String> _inputSuggestions = [];

  bool _isTyping = false;
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _textController.addListener(_handleTextChange);
    _scrollController.addListener(_checkScrollPosition);
    currentQuestionIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJournalEntry();
    });
  }

  void _checkScrollPosition() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _textFocusNode.requestFocus();
    }
  }

  void _handleTextChange() {
    final newIsTyping = _textController.text.trim().isNotEmpty;
    if (newIsTyping != _isTyping) {
      setState(() {
        _isTyping = newIsTyping;
      });
    }
  }

  Future<void> _loadJournalEntry() async {
    setState(() {
      _loadingState = _loadingState.copyWith(isInitialLoading: true);
    });

    try {
      await _store.dispatch(LoadJournalDetailAction(widget.journalEntryId));
      final journalEntry = _store.state.journalDetailState.selectedJournalEntry;
      if (journalEntry != null) {
        await _initializeQAList(journalEntry);
      } else {
        throw Exception('Journal entry not found');
      }
    } catch (e) {
      logger.e("JournalEntryPageState:_loadJournalEntry", error: e);
      _showError('Failed to load journal entry: $e');
    } finally {
      setState(() {
        _loadingState = _loadingState.copyWith(isInitialLoading: false);
      });
    }
  }

  Future<void> _initializeQAList(JournalEntryEntity journalEntry) async {
    qaList.clear();
    if (journalEntry.body != null && journalEntry.body!.isNotEmpty) {
      qaList.add({'question': 'What\'s on your mind?', 'answer': journalEntry.body!});
    }
    for (var question in journalEntry.questions ?? []) {
      if (question.questionText != null && question.answerText != null) {
        qaList.add({'question': question.questionText!, 'answer': question.answerText!});
      }
    }

    currentQuestionIndex = qaList.length - 1;
    if (qaList.isNotEmpty) {
      _textController.text = qaList.last['answer'] ?? '';
      await _goDeeper(useExistingAnswer: true);
    }
  }

  Future<void> _saveAnswer() async {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _loadingState = _loadingState.copyWith(isSaving: true);
      });

      try {
        if (currentQuestionIndex < qaList.length) {
          qaList[currentQuestionIndex]['answer'] = _textController.text;
        } else {
          qaList.add({'question': qaList.last['question'] ?? '', 'answer': _textController.text});
        }

        final journalEntry = _store.state.journalDetailState.selectedJournalEntry;
        if (journalEntry != null) {
          await _store.dispatch(UpdateQuestionAnswer(
            journalEntryId: journalEntry.id,
            questionId: qaList[currentQuestionIndex]['questionId'] ?? uuid.v4(),
            answerText: _textController.text,
            questionText: qaList[currentQuestionIndex]['question']!,
          ));
        }
      } catch (e) {
        logger.e("JournalEntryPageState:_saveAnswer", error: e);
        _showError('Failed to save answer: $e');
      } finally {
        setState(() {
          _loadingState = _loadingState.copyWith(isSaving: false);
        });
      }
    }
  }

  Future<void> _goDeeper({bool useExistingAnswer = false}) async {
    if (_textController.text.trim().isEmpty) {
      _showError('Please write an answer before continuing');
      return;
    }

    if (!useExistingAnswer) {
      await _saveAnswer();
    }

    setState(() {
      _loadingState = _loadingState.copyWith(isGeneratingQuestion: true);
    });

    try {
      final deeperQuestionResponse = await AIQuestionAPI().generateDeeperQuestion(
        QAData(qaList: qaList),
      );

      setState(() {
        qaList.add({
          'question': deeperQuestionResponse['question'],
          'answer': '',
        });
        _helpText = deeperQuestionResponse['helpText'];
        _inputSuggestions = (deeperQuestionResponse['inputSuggestions'] as List<dynamic>).cast<String>();
        currentQuestionIndex = qaList.length - 1;
        showingAlternatives = false;
        _textController.clear();
        _isTyping = false; // Reset typing state
      });
      _scrollToBottom();
    } catch (e) {
      logger.e("JournalEntryPageState:_goDeeper", error: e);
      _showError('Failed to generate new question: $e');
    } finally {
      setState(() {
        _loadingState = _loadingState.copyWith(isGeneratingQuestion: false);
      });
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _loadingState.isSaving ? null : _saveAndExit,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: _loadingState.isSaving ? null : _saveAndExit,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _loadingState.isInitialLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      controller: _scrollController,
                      children: [
                        ...qaList.asMap().entries.map((entry) => _buildQuestionAnswerItem(entry.key, colorScheme)),
                        if (showingAlternatives) _buildAlternativesSection(colorScheme),
                      ],
                    ),
            ),
            _buildBottomInputArea(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInputArea(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                hintText: 'Write your answer...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: null,
              textInputAction: TextInputAction.newline,
              onChanged: (text) {
                setState(() {
                  _isTyping = text.trim().isNotEmpty;
                });
              },
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _determineButtonAction(),
            child: Icon(_isTyping ? AntDesign.right : AntDesign.check),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _determineButtonAction() {
    if (_loadingState.isGeneratingQuestion) {
      return null;
    }
    if (_isTyping) {
      return _goDeeper;
    }
    return _saveAndExit;
  }

  Future<void> _showAlternatives() async {
    setState(() {
      _loadingState = _loadingState.copyWith(isGeneratingQuestion: true);
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
        _loadingState = _loadingState.copyWith(isGeneratingQuestion: false);
      });
    }
    _scrollToBottom();
  }

  Widget _buildQuestionAnswerItem(int index, ColorScheme colorScheme) {
    final isCurrentQuestion = index == currentQuestionIndex;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCurrentQuestion && _helpText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(_helpText!,
                  style: TextStyle(fontStyle: FontStyle.italic, color: colorScheme.onSurface.withOpacity(0.6))),
            ),
          Text(qaList[index]['question']!, style: TextStyle(fontWeight: FontWeight.bold)),
          if (isCurrentQuestion && !showingAlternatives && !_loadingState.isGeneratingQuestion)
            TextButton(
              onPressed: _showAlternatives,
              child: Text('Change Question'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            ),
          if (!isCurrentQuestion)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(qaList[index]['answer']!),
            ),
          if (isCurrentQuestion && _inputSuggestions.isNotEmpty)
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: _inputSuggestions
                  .map((suggestion) => GestureDetector(
                        onTap: () => _onInputSuggestionSelected(suggestion),
                        child: Chip(
                          label: Text(suggestion, style: TextStyle(fontSize: 12)),
                          padding: EdgeInsets.all(4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ))
                  .toList(),
            ),
          if (isCurrentQuestion && _loadingState.isGeneratingQuestion) const CircularProgressIndicator(),
        ],
      ),
    );
  }

  bool get _isLastQuestion => qaList.length >= 2 && currentQuestionIndex == qaList.length - 1;

  void _handleContinueOrDone() {
    if (_isLastQuestion) {
      _saveAndExit();
    } else {
      _goDeeper();
    }
  }

  Widget _buildAlternativesSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose a different question:', style: TextStyle(fontWeight: FontWeight.bold)),
          ..._alternativeQuestions.map((question) => ListTile(
                title: Text(question),
                onTap: () => _selectAlternative(question),
              )),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: _showAlternatives, child: Text('Regenerate'))),
              SizedBox(width: 16),
              Expanded(child: ElevatedButton(onPressed: _backToWriting, child: Text('Back to writing'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool isLastQuestion = qaList.length >= 2;
    final String buttonText = (isLastQuestion && !_isTyping) ? "Done" : "Continue";
    final IconData buttonIcon = (isLastQuestion && !_isTyping) ? Icons.check : Icons.arrow_downward;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Button(
        text: buttonText,
        icon: buttonIcon,
        onPressed: _textController.text.trim().isEmpty || _loadingState.isGeneratingQuestion
            ? null
            : (isLastQuestion && !_isTyping)
                ? _saveAndExit
                : _goDeeper,
      ),
    );
  }

  void _onInputSuggestionSelected(String suggestion) {
    setState(() {
      if (_textController.text.isEmpty) {
        _textController.text = suggestion;
      } else {
        _textController.text += ' ' + suggestion;
      }
      _inputSuggestions.remove(suggestion);
    });
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
  }

  void _selectAlternative(String question) {
    setState(() {
      qaList[currentQuestionIndex]['question'] = question;
      showingAlternatives = false;
      _textController.clear();
    });
    _scrollToBottom();
  }

  void _backToWriting() {
    setState(() {
      showingAlternatives = false;
    });
  }

  Future<void> _saveAndExit() async {
    if (_loadingState.isSaving) return;

    setState(() {
      _loadingState = _loadingState.copyWith(isSaving: true);
      _errorMessage = null;
    });

    try {
      await _saveAnswer(); // Save the current answer before exiting
      final journalEntry = _store.state.journalDetailState.selectedJournalEntry;
      if (journalEntry != null) {
        await _store.dispatch(LoadJournalDetailAction(journalEntry.id));
        _navigateToDetailPage(context, journalEntry.id);
      } else {
        throw Exception('Journal entry not found');
      }
    } catch (e) {
      logger.e("JournalEntryPageState:_saveAndExit", error: e);
      _showError('Failed to save and exit: $e');
      GoRouter.of(context).pushNamed(RootPath.home);
    } finally {
      if (mounted) {
        setState(() {
          _loadingState = _loadingState.copyWith(isSaving: false);
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

  @override
  void dispose() {
    _textController.removeListener(_handleTextChange);
    _scrollController.removeListener(_checkScrollPosition);
    _textController.dispose();
    _scrollController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }
}
