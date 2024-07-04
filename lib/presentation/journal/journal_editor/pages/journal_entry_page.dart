import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/infrastructure/api/ai_question_api.dart';
import 'package:teja/presentation/journal/journal_editor/ui/typing_indicator.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class JournalEntryPage extends StatefulWidget {
  final List<Map<String, String>> initialQAList;

  const JournalEntryPage({super.key, required this.initialQAList});

  @override
  JournalEntryPageState createState() => JournalEntryPageState();
}

class JournalEntryPageState extends State<JournalEntryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late List<Map<String, String>> qaList;

  final TextEditingController _textController = TextEditingController();
  late int currentQuestionIndex;
  bool showingAlternatives = false;
  List<String> _alternativeQuestions = [];

  @override
  void initState() {
    super.initState();
    qaList = List.from(widget.initialQAList);
    currentQuestionIndex = qaList.length - 1;
    _textController.addListener(_scrollToBottom);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate new question: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _goDeeper({bool useExistingAnswer = false}) async {
    setState(() {
      _isLoading = true;
      if (!useExistingAnswer) {
        qaList[currentQuestionIndex]['answer'] = _textController.text;
        _textController.clear();
      }
    });

    try {
      final authToken = await SecureStorage().readAccessToken();
      final deeperQuestionResponse = await AIQuestionAPI().generateDeeperQuestion(
        authToken!,
        QAData(qaList: qaList),
      );

      setState(() {
        qaList.add({
          'question': deeperQuestionResponse['question'],
          'answer': '',
        });
        currentQuestionIndex++;
        showingAlternatives = false;
      });
    } catch (e) {
      logger.e("JournalEntryPageState:_goDeeper", error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate new question: $e')),
      );
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
      final authToken = await SecureStorage().readAccessToken();
      final alternativeQuestionsResponse = await AIQuestionAPI().generateAlternativeQuestions(
        authToken!,
        QAData(qaList: qaList),
      );

      setState(() {
        _alternativeQuestions =
            (alternativeQuestionsResponse['alternatives'] as List<dynamic>).map((alt) => alt.toString()).toList();
        showingAlternatives = true;
      });
    } catch (e) {
      logger.e("JournalEntryPageState:_showAlternatives", error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate alternative questions: $e')),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('New entry'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: const Icon(Icons.done), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
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
                        style: const TextStyle(fontSize: 18, color: Colors.blue),
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
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Continue'),
                        onPressed: () => _goDeeper(useExistingAnswer: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
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
                                child: Text(
                                  question,
                                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                                ),
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
    );
  }
}
