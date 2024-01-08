import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/shared/common/button.dart';

class JournalQuestionPage extends StatefulWidget {
  final JournalEntryEntity journalEntry;
  final int questionIndex; // Add this line to receive the question index

  const JournalQuestionPage({
    Key? key,
    required this.journalEntry, // Changed to required
    required this.questionIndex, // Add this line
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
    String initialText = widget.journalEntry.questions![widget.questionIndex].answerText ?? '';
    textEditingController = TextEditingController(text: initialText);
    textEditingController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), _saveAnswer);
  }

  void _saveAnswer() {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(UpdateQuestionAnswer(
      journalEntryId: widget.journalEntry.id,
      questionId: widget.journalEntry.questions![widget.questionIndex].questionId!,
      answerText: textEditingController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.journalEntry.questions![widget.questionIndex];
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                question.questionText!,
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
                  decoration: const InputDecoration(
                    hintText: 'Write your response here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Center(
              // Center the button horizontally
              child: Container(
                color: colorScheme.background,
                padding: const EdgeInsets.all(10.0),
                child: Button(
                  text: "Next",
                  width: 300,
                  onPressed: () async {
                    FocusScope.of(context).unfocus(); // Dismiss the keyboard
                    await Future.delayed(const Duration(milliseconds: 100)); // Wait for keyboard to dismiss
                    // final store = StoreProvider.of<AppState>(context);
                    // store.dispatch(ChangeJournalPageAction(viewModel.currentPageIndex + 1));
                  },
                  buttonType: ButtonType.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
