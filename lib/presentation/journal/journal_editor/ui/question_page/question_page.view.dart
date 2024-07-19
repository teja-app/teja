import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/action_bar/bottom_action_bar.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_page.model.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_widget/question_text.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_widget/response_field.dart';

class JournalQuestionPage extends StatefulWidget {
  final int questionIndex;

  const JournalQuestionPage({
    Key? key,
    required this.questionIndex,
  }) : super(key: key);

  @override
  JournalQuestionPageState createState() => JournalQuestionPageState();
}

class JournalQuestionPageState extends State<JournalQuestionPage> with WidgetsBindingObserver {
  late FocusNode textFocusNode;
  List<String> suggestions = [];
  late TextEditingController textEditingController;
  Timer? _debounce;
  late final Store<AppState> _store;
  ValueNotifier<bool> isUserInputNotifier = ValueNotifier(false); // Using ValueNotifier for managing user input flag

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    textFocusNode = FocusNode();
    _store = StoreProvider.of<AppState>(context, listen: false);
    textFocusNode.addListener(() {
      if (!textFocusNode.hasFocus) {
        final viewModel = JournalQuestionViewModel.fromStore(_store, widget.questionIndex);
        saveAnswer(viewModel);
      }
    });
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final viewModel = JournalQuestionViewModel.fromStore(_store, widget.questionIndex);
    saveAnswer(viewModel);
    textFocusNode.dispose();
    textEditingController.dispose();
    isUserInputNotifier.dispose(); // Dispose the ValueNotifier
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final viewModel = JournalQuestionViewModel.fromStore(_store, widget.questionIndex);
    if (state == AppLifecycleState.paused) {
      saveAnswer(viewModel); // Save the text when the app is paused
    }
  }

  void saveAnswer(JournalQuestionViewModel viewModel) {
    _store.dispatch(UpdateQuestionAnswer(
      journalEntryId: viewModel.journalEntry.id,
      questionId: viewModel.journalEntry.questions![widget.questionIndex].questionId!,
      questionText: viewModel.journalEntry.questions![widget.questionIndex].questionText!,
      answerText: textEditingController.text,
    ));
  }

  void nextPage(JournalQuestionViewModel viewModel) {
    saveAnswer(viewModel);
    _store.dispatch(ChangeJournalPageAction(viewModel.currentPageIndex + 1));
  }

  Future<void> recordVideo(JournalQuestionViewModel viewModel) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      handleMediaType(video, viewModel);
    }
  }

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, JournalQuestionViewModel>(
      converter: (store) => JournalQuestionViewModel.fromStore(store, widget.questionIndex),
      builder: (context, viewModel) {
        final question = viewModel.journalEntry.questions![widget.questionIndex];

        if (textEditingController.text != question.answerText && !isUserInputNotifier.value) {
          textEditingController.text = question.answerText ?? '';
        }

        return Scaffold(
          bottomNavigationBar: buildBottomActionBar(
            context, viewModel, _picker, () => nextPage(viewModel), // Pass the nextPage function
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => textFocusNode.unfocus(),
                  behavior: HitTestBehavior.translucent,
                  child: Container(), // This container catches taps but is invisible and non-blocking
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildQuestionText(question.questionText ?? '', textTheme),
                  Divider(
                    color: Colors.grey[800], // You can adjust color here
                    thickness: 0.25, // You can adjust thickness here
                    indent: 20,
                    endIndent: 20,
                  ),
                  buildResponseField(
                    context,
                    Theme.of(context).textTheme,
                    viewModel,
                    textFocusNode,
                    textEditingController,
                    isUserInputNotifier,
                    widget.questionIndex,
                  ),
                  Divider(
                    color: Colors.grey[800], // You can adjust color here
                    thickness: 0.25, // You can adjust thickness here
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
