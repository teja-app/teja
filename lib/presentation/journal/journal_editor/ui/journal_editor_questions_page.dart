import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';

class JournalQuestionPage extends StatefulWidget {
  final JournalQuestionEntity question;
  final PageController pageController;
  final JournalEntryEntity? journalEntry;

  const JournalQuestionPage({
    Key? key,
    required this.question,
    required this.pageController,
    this.journalEntry,
  }) : super(key: key);

  @override
  JournalQuestionPageState createState() => JournalQuestionPageState();
}

class JournalQuestionPageState extends State<JournalQuestionPage> {
  late FocusNode textFocusNode;
  late TextEditingController textEditingController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    String initialText = widget.journalEntry?.questions
            ?.firstWhere(
              (q) => q.questionId == widget.question.id,
              orElse: () => QuestionAnswerPairEntity(),
            )
            ?.answerText ??
        '';
    textEditingController = TextEditingController(text: initialText);
    textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    textEditingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 1000), _saveAnswer);
  }

  void _saveAnswer() {
    // Dispatch action to save the answer
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(UpdateQuestionAnswer(
      journalEntryId: widget.journalEntry?.id ?? '',
      questionId: widget.question.id,
      answerText: textEditingController.text,
    ));
  }

  void _goToNextPage() {
    if (widget.pageController.hasClients) {
      final int currentIndex = widget.pageController.page?.toInt() ?? 0;
      final int totalLength = widget.pageController.positions.length;

      if (currentIndex < totalLength - 1) {
        _saveAnswer(); // Ensure answer is saved before navigating away
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        print("Last page reached");
        // Optionally handle the last page scenario (e.g., submit journal)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.question.text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: textEditingController,
                  focusNode: textFocusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: widget.question.placeholder ?? 'Write your response here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _goToNextPage,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
