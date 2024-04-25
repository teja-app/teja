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
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:teja/infrastructure/utils/image_storage_helper.dart';
import 'package:teja/infrastructure/utils/video_storage_helper.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/presentation/mood/ui/attachment_video.dart';
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

  Future<void> selectMedia(JournalQuestionViewModel viewModel) async {
    final List<XFile> mediaFiles = await _picker.pickMultipleMedia();

    if (mediaFiles.isNotEmpty) {
      for (XFile file in mediaFiles) {
        print("Media Path: ${file.path}");
        handleMediaType(file, viewModel);
      }
    } else {
      print("No media selected.");
    }
  }

  Future<void> handleMediaType(XFile media, JournalQuestionViewModel viewModel) async {
    String mediaPath = media.path.toLowerCase(); // Case-insensitive matching

    // Check file extension to determine media type
    if (mediaPath.endsWith('.jpg') ||
        mediaPath.endsWith('.png') ||
        mediaPath.endsWith('.jpeg') ||
        mediaPath.endsWith('.heic')) {
      print("Selected media is an image.");

      // Save the image permanently and get the relative path
      final String relativePath = await ImageStorageHelper.saveImagePermanently(media.path);

      var fileBytes = await media.readAsBytes();
      // Create an ImageEntry object with the permanent path
      ImageEntry imageEntry = ImageEntry()
        ..id = Helpers.generateUniqueId()
        ..filePath = relativePath // Use the relative path from permanent storage
        ..caption = ''
        ..hash = Helpers.generateHash(fileBytes);

      // Dispatch the action to add the image
      viewModel.addImage(
        viewModel.journalEntry.id,
        viewModel.journalEntry.questions![viewModel.questionIndex].id,
        imageEntry,
      );
    } else if (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov') || mediaPath.endsWith('.avi')) {
      print("Selected media is a video.");

      // Save the video permanently and get the relative path
      final String relativePath = await VideoStorageHelper.saveVideoPermanently(media.path);

      var fileBytes = await media.readAsBytes();
      // Create a VideoEntry object with the permanent path
      VideoEntry videoEntry = VideoEntry()
        ..id = Helpers.generateUniqueId()
        ..filePath = relativePath // Use the relative path from permanent storage
        ..duration = 0 // You can update this with the actual video duration if needed
        ..hash = Helpers.generateHash(fileBytes);

      // Dispatch the action to add the video
      viewModel.addVideo(
        viewModel.journalEntry.id,
        viewModel.journalEntry.questions![viewModel.questionIndex].id,
        videoEntry,
      );
    } else {
      print("Unknown or unsupported media type: ${media.path}");
      // Optionally handle unknown types, show error, or log
    }
  }

  Future<void> _recordVideo(JournalQuestionViewModel viewModel) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      // Handle the video file
      print("Video Path: ${video.path}");
      handleMediaType(video, viewModel);
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (text) => setState(() => isUserInput = true),
          ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Column(
          //     children: [
          //       IconButton(
          //         icon: const Icon(Icons.mic, color: Colors.white),
          //         onPressed: () {
          //           // Implement your recording logic here
          //         },
          //       ),
          //       _buildSelectedMediaScrollable(viewModel),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSelectedMediaScrollable(JournalQuestionViewModel viewModel) {
    // If both lists of images and videos are empty or null, return an empty widget
    if ((viewModel.imageEntries?.isEmpty ?? true) && (viewModel.videoEntries?.isEmpty ?? true)) {
      return SizedBox.shrink();
    }

    return Container(
      // Define a fixed width or use MediaQuery to set it relative to the screen size
      width: 50, // For example
      // Define a fixed height, so the ListView knows its scrolling direction's constraints
      height: MediaQuery.of(context).size.height - 200,

      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          if (viewModel.imageEntries != null)
            ...viewModel.imageEntries!.map((imageEntry) {
              return AttachmentImage(
                relativeImagePath: imageEntry.filePath!,
                width: 50,
                height: 30,
              );
            }).toList(),
          if (viewModel.videoEntries != null)
            ...viewModel.videoEntries!.map((videoEntry) {
              return AttachmentVideo(
                relativeVideoPath: videoEntry.filePath!,
                width: 50,
                height: 30,
              );
            }).toList(),
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
            icon: const Icon(Icons.image, color: Colors.white),
            onPressed: () => selectMedia(viewModel),
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white),
            onPressed: () => _recordVideo(viewModel),
          ),
          // IconButton(
          //   icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          //   onPressed: () {
          //     // Implement logic to expand input area
          //   },
          // ),
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
                  _buildResponseField(context, Theme.of(context).textTheme, viewModel),
                  const SizedBox(height: 10),
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
  final List<ImageEntryEntity>? imageEntries;
  final List<VideoEntryEntity>? videoEntries;

  final Function(String journalEntryId, String questionAnswerPairId, ImageEntry imageEntry) addImage;
  final Function(String journalEntryId, String questionAnswerPairId, VideoEntry videoEntry) addVideo;

  JournalQuestionViewModel({
    required this.journalEntry,
    required this.questionIndex,
    required this.currentPageIndex,
    required this.addImage,
    required this.addVideo,
    this.imageEntries,
    this.template,
    this.videoEntries,
  });

  static JournalQuestionViewModel fromStore(Store<AppState> store, int questionIndex) {
    final currentJournalEntry = store.state.journalEditorState.currentJournalEntry!;
    JournalTemplateEntity? template;
    if (currentJournalEntry.templateId != null) {
      template = store.state.journalTemplateState.templatesById[currentJournalEntry.templateId];
    }

    final imageEntryIds = currentJournalEntry.questions![questionIndex].imageEntryIds;

    final imageEntries = currentJournalEntry.imageEntries == null
        ? null
        : List<ImageEntryEntity>.from(
            currentJournalEntry.imageEntries!.where(
              (entry) {
                print("entry ${entry.id}");
                return imageEntryIds?.contains(entry.id) ?? false;
              },
            ).map((entry) => (entry)),
          );

    final videoEntryIds = currentJournalEntry.questions![questionIndex].videoEntryIds;

    final videoEntries = currentJournalEntry.videoEntries == null
        ? null
        : List<VideoEntryEntity>.from(
            currentJournalEntry.videoEntries!.where(
              (entry) {
                print("entry ${entry.id}");
                return videoEntryIds?.contains(entry.id) ?? false;
              },
            ).map((entry) => (entry)),
          );

    return JournalQuestionViewModel(
      journalEntry: currentJournalEntry,
      currentPageIndex: store.state.journalEditorState.currentPageIndex,
      questionIndex: questionIndex,
      template: template,
      imageEntries: imageEntries,
      addImage: (journalEntryId, questionAnswerPairId, imageEntry) => store.dispatch(AddImageToQuestionAnswerPair(
        journalEntryId: journalEntryId,
        questionAnswerPairId: questionAnswerPairId,
        imageEntry: imageEntry,
      )),
      videoEntries: videoEntries,
      addVideo: (journalEntryId, questionAnswerPairId, videoEntry) => store.dispatch(AddVideoToQuestionAnswerPair(
        journalEntryId: journalEntryId,
        questionAnswerPairId: questionAnswerPairId,
        videoEntry: videoEntry,
      )),
    );
  }
}
