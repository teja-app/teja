import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:teja/infrastructure/utils/image_storage_helper.dart';
import 'package:teja/shared/common/button.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class NotesScreen extends StatefulWidget {
  final PageController pageController;

  const NotesScreen({Key? key, required this.pageController}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  late FocusNode textFocusNode;
  late TextEditingController textEditingController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    textEditingController = TextEditingController();
    textEditingController.addListener(_onTextChanged);
    textFocusNode.addListener(() {
      if (!textFocusNode.hasFocus) {
        _saveComment();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the active debounce timer if it exists
    textFocusNode.dispose(); // Dispose of the FocusNode
    textEditingController.removeListener(_onTextChanged); // Remove the text change listener
    textEditingController.dispose(); // Dispose of the TextEditingController
    super.dispose();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _saveComment);
  }

  void _saveComment() {
    final store = StoreProvider.of<AppState>(context);
    final currentMoodLogId = StoreProvider.of<AppState>(context).state.moodEditorState.currentMoodLog!.id;
    final comment = textEditingController.text;

    store.dispatch(UpdateMoodLogCommentAction(currentMoodLogId, comment));
  }

  Widget _buildUploadButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          // Save the image to the app's directory
          final String relativePath = await ImageStorageHelper.saveImagePermanently(pickedFile.path);

          // Generate a unique ID for the attachment (ensure you have a method for this)
          String attachmentId = Helpers.generateUniqueId();

          // Create a new attachment entity with the relative path
          MoodLogAttachmentEntity newAttachment = MoodLogAttachmentEntity(
            id: attachmentId,
            type: 'image',
            path: relativePath, // Store the relative path
          );

          // Dispatch an action to add this attachment
          final store = StoreProvider.of<AppState>(context);
          store.dispatch(AddAttachmentAction(
            moodLogId: store.state.moodEditorState.currentMoodLog!.id,
            attachment: newAttachment,
          ));
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: Colors.grey[600]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      child: StoreConnector<AppState, NotesScreenModel>(
        converter: (store) => NotesScreenModel.fromStore(store),
        builder: (context, viewModel) {
          if (textEditingController.text.isEmpty && viewModel.comment != null) {
            textEditingController.text = viewModel.comment!;
          }

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: textEditingController,
                        maxLines: null,
                        focusNode: textFocusNode,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Write your feelings or notes here...',
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Attachments',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _buildAttachmentsList(viewModel.moodLogId, viewModel.attachments, context),
                Container(
                  color: colorScheme.background,
                  padding: const EdgeInsets.all(10.0),
                  child: Button(
                    text: "Next",
                    width: 300,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));
                      final store = StoreProvider.of<AppState>(context);
                      store.dispatch(ChangePageAction(viewModel.currentPageIndex + 1));
                    },
                    buttonType: ButtonType.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttachmentImage(String relativeImagePath) {
    return FutureBuilder<File>(
      future: ImageStorageHelper.getImage(relativeImagePath),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // When the Future is resolved
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(snapshot.data!),
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          // While the Future is loading
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Placeholder color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: CircularProgressIndicator()), // Loading indicator
          );
        } else {
          // If an error occurs
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Placeholder color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.error), // Error icon
          );
        }
      },
    );
  }

  Widget _buildAttachmentsList(String moodLogId, List<MoodLogAttachmentEntity> attachments, BuildContext context) {
    return SizedBox(
      height: 120, // Adjust the container height to fit the content
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length + 1, // +1 for the upload button
        itemBuilder: (BuildContext context, int index) {
          if (index == attachments.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildUploadButton(context),
            );
          }
          MoodLogAttachmentEntity attachment = attachments[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                _buildAttachmentImage(attachment.path), // Refactor to use FutureBuilder
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      final store = StoreProvider.of<AppState>(context);
                      store.dispatch(RemoveAttachmentAction(
                        moodLogId: moodLogId,
                        attachmentId: attachment.id,
                      ));
                    },
                    child: const Icon(Icons.remove_circle, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NotesScreenModel {
  final String moodLogId;
  final String? comment;
  final List<MoodLogAttachmentEntity> attachments; // Include attachments in the model
  final int currentPageIndex;

  NotesScreenModel({
    required this.moodLogId,
    this.comment,
    required this.attachments, // Initialize attachments
    required this.currentPageIndex,
  });

  static NotesScreenModel fromStore(Store<AppState> store) {
    return NotesScreenModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      comment: store.state.moodEditorState.currentMoodLog?.comment,
      attachments: store.state.moodEditorState.currentMoodLog?.attachments ?? [], // Fetch attachments from the state
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
    );
  }
}
