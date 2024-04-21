import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

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
                leading: const Icon(Icons.lightbulb_outline),
                title: const Text('Idea'),
                onTap: () => Navigator.of(context).pop('ideas'),
              ),
              ListTile(
                leading: const Icon(Icons.chair_alt_outlined),
                title: const Text('Challenge'),
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

  Widget _buildQuestionText(String questionText, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        questionText,
        style: textTheme.bodySmall,
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

  // Function to handle image selection
  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle the image file
      print("Image Path: ${image.path}");
    }
  }

  // Function to handle video recording
  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      // Handle the video file
      print("Video Path: ${video.path}");
    }
  }

  Widget _buildResponseField(BuildContext context, TextTheme textTheme, JournalQuestionViewModel viewModel) {
    return Expanded(
      child: Stack(
        children: [
          TextField(
            focusNode: textFocusNode,
            controller: textEditingController,
            cursorOpacityAnimates: false,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            expands: true,
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Write your response here...',
              hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (text) => setState(() => isUserInput = true),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: IconButton(
              icon: Icon(Icons.mic, color: Colors.white),
              onPressed: () {
                // Implement video selection logic
              },
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage(BuildContext context, JournalQuestionViewModel viewModel) {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(ChangeJournalPageAction(viewModel.currentPageIndex + 1));
  }

  Widget _buildBottomActionBar(BuildContext context, JournalQuestionViewModel viewModel) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.photo, color: Colors.white),
            onPressed: _selectImage,
          ),
          IconButton(
            icon: Icon(Icons.video_call, color: Colors.white),
            onPressed: _recordVideo,
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              // Implement logic to expand input area
            },
          ),
          ElevatedButton(
            onPressed: () => _nextPage(context, viewModel),
            child: const Icon(Icons.check, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(TextTheme textTheme) {
    return Expanded(
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return FlexibleHeightBox(
            gridWidth: 4,
            child: Flexible(
              child: SelectableText(
                suggestions[index],
                style: const TextStyle(fontSize: 10.0),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, JournalQuestionViewModel>(
      converter: (store) => JournalQuestionViewModel.fromStore(store, widget.questionIndex),
      builder: (context, viewModel) {
        final question = viewModel.journalEntry.questions![widget.questionIndex];

        if (textEditingController.text != question.answerText && !isUserInput) {
          textEditingController.text = question.answerText ?? '';
        }

        return Scaffold(
          bottomNavigationBar: _buildBottomActionBar(context, viewModel),
          body: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => textFocusNode.unfocus(),
                  behavior: HitTestBehavior.translucent, // Make sure it registers taps without blocking them
                  child: Container(), // This container catches taps but is invisible and non-blocking
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionText(question.questionText ?? '', textTheme),
                  const SizedBox(height: 10),
                  _buildResponseField(context, textTheme, viewModel),
                  // _buildActionButtons(context, viewModel),
                  const SizedBox(height: 10), // Adjusted spacing
                  Visibility(
                    visible: suggestions.isNotEmpty,
                    child: _buildSuggestions(textTheme),
                  ),
                ],
              ),
            ],
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
