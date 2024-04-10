import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:teja/theme/padding.dart'; // Import the re_editor package

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
  List<String> suggestions = [];
  late TextEditingController textEditingController;
  Timer? _debounce;
  bool isUserInput = false;

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    textFocusNode.addListener(() {
      if (!textFocusNode.hasFocus) {
        _saveAnswer();
      }
    });
    textEditingController = TextEditingController();
    textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    textEditingController.removeListener(_onTextChanged);
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

  Future<void> _showSuggestionOptions(BuildContext context) async {
    final type = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.lightbulb_outline),
                title: Text('Idea'),
                onTap: () => Navigator.of(context).pop('ideas'),
              ),
              ListTile(
                leading: Icon(Icons.chair_alt_outlined),
                title: Text('Challenge'),
                onTap: () => Navigator.of(context).pop('challenge'),
              ),
              // Add more options as needed
            ],
          ),
        );
      },
    );

    if (type != null) {
      _fetchAndDisplaySuggestions(type);
    }
  }

  Future<void> _fetchAndDisplaySuggestions(String guidanceType) async {
    // Access the viewModel for the current state.
    final viewModel = StoreProvider.of<AppState>(context).state.journalEditorState.currentJournalEntry;
    final templateModel = StoreProvider.of<AppState>(context).state.journalTemplateState;

    String journalTitle = "Default Title";
    if (viewModel?.templateId != null) {
      journalTitle = templateModel.templatesById[viewModel?.templateId]!.title;
    }
    final String journalPrompt =
        viewModel?.questions?[widget.questionIndex].questionText ?? "Default Description"; // Fallback description
    final String userInput = textEditingController.text ?? "No Input"; // Directly use the user's current input
    try {
      final Dio dio = Dio();
      final response = await dio.post(
        'https://lively-darkness-d1b6.ray-719.workers.dev',
        data: {
          "journalTitle": journalTitle,
          "journalPrompt": journalPrompt,
          "guidanceType": guidanceType,
          "userInput": userInput,
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        print("response.data ${response.data}");
        final List<String> fetchedSuggestions = [
          response.data as String
        ]; // Modify this line based on the actual data structure
        setState(() {
          suggestions = fetchedSuggestions;
        });
      } else {
        print("Failed to fetch suggestions: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error making the request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150, // Specify the height explicitly
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: textEditingController,
                      cursorOpacityAnimates: false, // Note: Important for performance.
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: textTheme.bodyMedium,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // Center the buttons horizontally
                  children: [
                    IconButton(
                      icon: Icon(FlutterIcons.magic_faw),
                      onPressed: () => _showSuggestionOptions(context),
                    ),
                    SizedBox(width: 20), // Provides some spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        final store = StoreProvider.of<AppState>(context);
                        store.dispatch(ChangeJournalPageAction(viewModel.currentPageIndex + 1));
                      },
                      child: Icon(Icons.check, color: Colors.black), // Use a check icon for the "Next" action
                    ),
                  ],
                ),
                SizedBox(height: smallSpacer),
                suggestions.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SelectableText(
                          "Suggestion",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ListView.separated(
                    itemCount: suggestions.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      return FlexibleHeightBox(
                        gridWidth: 4,
                        child: Flexible(
                          child: SelectableText(
                            suggestions[index],
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ),
                      );
                    },
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
  JournalTemplateEntity? template;

  JournalQuestionViewModel({
    required this.journalEntry,
    required this.questionIndex,
    required this.currentPageIndex,
    this.template,
  });

  static JournalQuestionViewModel fromStore(Store<AppState> store, int questionIndex) {
    final currentJournalEntry = store.state.journalEditorState.currentJournalEntry!;
    JournalTemplateEntity? template;
    if (currentJournalEntry.templateId != null) {
      template = store.state.journalTemplateState.templatesById[currentJournalEntry.templateId];
    }
    return JournalQuestionViewModel(
      journalEntry: currentJournalEntry,
      currentPageIndex: store.state.journalEditorState.currentPageIndex,
      questionIndex: questionIndex,
      template: template,
    );
  }
}
