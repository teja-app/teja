import 'dart:convert';

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
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:teja/router.dart';
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
  final quill.QuillController _quillController = quill.QuillController.basic();

  LoadingState _loadingState = const LoadingState();
  String? _errorMessage; // ignore: unused_field
  List<Map<String, String>> qaList = [];

  // final TextEditingController _textController = TextEditingController();
  late int currentQuestionIndex;
  bool showingAlternatives = false;
  List<String> _alternativeQuestions = [];
  late final Store<AppState> _store;
  final Uuid uuid = const Uuid();
  String? _helpText;
  List<String> _inputSuggestions = [];

  bool _isTyping = false;
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _scrollController.addListener(_checkScrollPosition);
    currentQuestionIndex = 0;
    _quillController.addListener(_handleTextChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJournalEntry();
    });
  }

  void _handleTextChange() {
    // final newIsTyping = _textController.text.trim().isNotEmpty;
    final newIsTyping =
        _quillController.document.toPlainText().trim().isNotEmpty;
    if (newIsTyping != _isTyping) {
      setState(() {
        _isTyping = newIsTyping;
      });
    }
  }

  void _checkScrollPosition() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _textFocusNode.requestFocus();
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
      qaList.add(
          {'question': 'What\'s on your mind?', 'answer': journalEntry.body!});
    }
    for (var question in journalEntry.questions ?? []) {
      if (question.questionText != null && question.answerText != null) {
        qaList.add({
          'question': question.questionText!,
          'answer': question.answerText!
        });
      }
    }

    currentQuestionIndex = qaList.length - 1;
    if (qaList.isNotEmpty) {
      // _textController.text = qaList.last['answer'] ?? '';
      _quillController.replaceText(0, 0, qaList.last['answer'] ?? '',
          const TextSelection.collapsed(offset: 0));
      await _goDeeper(useExistingAnswer: true);
    }
  }

  Future<void> _saveAnswer() async {
    // if (_textController.text.isNotEmpty) {
    if (_quillController.document.toPlainText().trim().isNotEmpty) {
      setState(() {
        _loadingState = _loadingState.copyWith(isSaving: true);
      });

      try {
        if (currentQuestionIndex < qaList.length) {
          qaList[currentQuestionIndex]['answer'] =
              jsonEncode(_quillController.document.toDelta().toJson());
        } else {
          qaList.add({
            'question': qaList.last['question'] ?? '',
            'answer': jsonEncode(_quillController.document.toDelta().toJson())
          });
        }

        final journalEntry =
            _store.state.journalDetailState.selectedJournalEntry;
        if (journalEntry != null) {
          await _store.dispatch(UpdateQuestionAnswer(
            journalEntryId: journalEntry.id,
            questionId: qaList[currentQuestionIndex]['questionId'] ?? uuid.v4(),
            answerText:
                jsonEncode(_quillController.document.toDelta().toJson()),
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
    if (_quillController.document.toPlainText().trim().isEmpty) {
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
      final deeperQuestionResponse =
          await AIQuestionAPI().generateDeeperQuestion(
        QAData(qaList: qaList),
      );

      setState(() {
        qaList.add({
          'question': deeperQuestionResponse['question'],
          'answer': '',
        });
        _helpText = deeperQuestionResponse['helpText'];
        _inputSuggestions =
            (deeperQuestionResponse['inputSuggestions'] as List<dynamic>)
                .cast<String>();
        currentQuestionIndex = qaList.length - 1;
        showingAlternatives = false;
        _quillController.clear();
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
    Future.delayed(const Duration(seconds: 3), () {
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
                        ...qaList.asMap().entries.map((entry) =>
                            _buildQuestionAnswerItem(entry.key, colorScheme)),
                        if (showingAlternatives)
                          _buildAlternativesSection(colorScheme),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              constraints: const BoxConstraints(
                maxHeight: 150, // Set a max height to allow scrolling
              ),
              child: quill.QuillEditor(
                focusNode: _textFocusNode,
                scrollController: ScrollController(), // Enables scrolling
                configurations: quill.QuillEditorConfigurations(
                  controller: _quillController,
                  placeholder: 'Write your answer...',
                  expands: false,
                  showCursor: true,
                  textCapitalization: TextCapitalization.sentences,
                  scrollable: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  autoFocus: true,
                  textInputAction: TextInputAction.done,
                  enableMarkdownStyleConversion: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _determineButtonAction(),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Icon(_isTyping ? AntDesign.right : AntDesign.check),
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
      final alternativeQuestionsResponse =
          await AIQuestionAPI().generateAlternativeQuestions(
        QAData(qaList: qaList),
      );

      setState(() {
        _alternativeQuestions =
            (alternativeQuestionsResponse['alternatives'] as List<dynamic>)
                .map((alt) => alt.toString())
                .toList();
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
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withValues(alpha: 0.6))),
            ),
          Text(qaList[index]['question']!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          if (isCurrentQuestion &&
              !showingAlternatives &&
              !_loadingState.isGeneratingQuestion)
            TextButton(
              onPressed: _showAlternatives,
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
              child: const Text('Change Question'),
            ),
          if (!isCurrentQuestion)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: (() {
                final answer = qaList[index]['answer'];
                try {
                  // Attempt to parse the answer as JSON
                  final parsedJson = jsonDecode(answer!);
                  // If parsing is successful, return QuillEditor
                  return quill.QuillEditor.basic(
                    configurations: quill.QuillEditorConfigurations(
                      controller: quill.QuillController(
                        document: quill.Document.fromJson(parsedJson),
                        selection: TextSelection.collapsed(offset: 0),
                        readOnly: true,
                      ),
                    ),
                  );
                } catch (e) {
                  // If parsing fails, return a Text widget
                  return Text(answer!);
                }
              })(),
            ),
          if (isCurrentQuestion && _inputSuggestions.isNotEmpty)
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: _inputSuggestions
                  .map((suggestion) => GestureDetector(
                        onTap: () => _onInputSuggestionSelected(suggestion),
                        child: Chip(
                          label: Text(suggestion, style: const TextStyle(fontSize: 12)),
                          padding: const EdgeInsets.all(4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ))
                  .toList(),
            ),
          if (isCurrentQuestion && _loadingState.isGeneratingQuestion)
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  // ignore: unused_element
  bool get _isLastQuestion =>
      qaList.length >= 2 && currentQuestionIndex == qaList.length - 1;


  Widget _buildAlternativesSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose a different question:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ..._alternativeQuestions.map((question) => ListTile(
                title: Text(question),
                onTap: () => _selectAlternative(question),
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: _showAlternatives, child: const Text('Regenerate'))),
              const SizedBox(width: 16),
              Expanded(
                  child: ElevatedButton(
                      onPressed: _backToWriting,
                      child: const Text('Back to writing'))),
            ],
          ),
        ],
      ),
    );
  }


  void _onInputSuggestionSelected(String suggestion) {
    setState(() {
      if (_quillController.document.toPlainText().trim().isEmpty) {
        _quillController.replaceText(0, 0, suggestion,
            TextSelection.collapsed(offset: suggestion.length));
      } else {
        _quillController.replaceText(
            _quillController.document.toPlainText().trim().length,
            0,
            ' $suggestion',
            TextSelection.collapsed(
                offset:
                    _quillController.document.length + suggestion.length + 1));
      }
      _inputSuggestions.remove(suggestion);
    });
    _quillController.updateSelection(
        TextSelection.collapsed(offset: _quillController.document.length - 1),
        ChangeSource.local);
  }

  void _selectAlternative(String question) {
    setState(() {
      qaList[currentQuestionIndex]['question'] = question;
      showingAlternatives = false;
      _quillController.clear();
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
        if (!mounted) return;
        _navigateToDetailPage(context, journalEntry.id);
      } else {
        throw Exception('Journal entry not found');
      }
    } catch (e) {
      logger.e("JournalEntryPageState:_saveAndExit", error: e);
      _showError('Failed to save and exit: $e');
      if (!mounted) return;
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
    _quillController.removeListener(_checkScrollPosition);
    _scrollController.removeListener(_checkScrollPosition);
    _quillController.dispose();
    _scrollController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }
}
