import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/shared/common/button.dart';

class JournalQuestionPage extends StatefulWidget {
  final int questionIndex;

  const JournalQuestionPage({
    Key? key,
    required this.questionIndex,
  }) : super(key: key);

  @override
  JournalQuestionPageState createState() => JournalQuestionPageState();
}

class JournalQuestionPageState extends State<JournalQuestionPage> {
  late FocusNode textFocusNode;
  late TextEditingController textEditingController;
  Timer? _debounce;
  bool isUserInput = false; // Flag to track if the change is user-initiated

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    textEditingController = TextEditingController();
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
    if (isUserInput) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), _saveAnswer);
    }
  }

  void _saveAnswer() {
    final store = StoreProvider.of<AppState>(context);
    final viewModel = JournalQuestionViewModel.fromStore(store, widget.questionIndex);
    store.dispatch(UpdateQuestionAnswer(
      journalEntryId: viewModel.journalEntry.id,
      questionId: viewModel.journalEntry.questions![widget.questionIndex].questionId!,
      answerText: textEditingController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JournalQuestionViewModel>(
      converter: (store) => JournalQuestionViewModel.fromStore(store, widget.questionIndex),
      builder: (context, viewModel) {
        final question = viewModel.journalEntry.questions![widget.questionIndex];

        if (textEditingController.text != question.answerText) {
          isUserInput = false; // Disable user input flag when programmatically updating
          textEditingController.text = question.answerText ?? '';
        }

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
                      onChanged: (text) {
                        isUserInput = true; // Set the flag to true when the user types
                      },
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    color: colorScheme.background,
                    padding: const EdgeInsets.all(10.0),
                    child: Button(
                      text: "Next",
                      width: 300,
                      onPressed: () {
                        final store = StoreProvider.of<AppState>(context);
                        store.dispatch(ChangeJournalPageAction(viewModel.currentPageIndex + 1));
                      },
                      buttonType: ButtonType.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class JournalQuestionViewModel {
  final JournalEntryEntity journalEntry;
  final int questionIndex;
  final int currentPageIndex;

  JournalQuestionViewModel({
    required this.journalEntry,
    required this.questionIndex,
    required this.currentPageIndex,
  });

  static JournalQuestionViewModel fromStore(Store<AppState> store, int questionIndex) {
    return JournalQuestionViewModel(
      journalEntry: store.state.journalEditorState.currentJournalEntry!,
      currentPageIndex: store.state.journalEditorState.currentPageIndex,
      questionIndex: questionIndex,
    );
  }
}
