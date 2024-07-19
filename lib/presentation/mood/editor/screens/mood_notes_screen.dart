import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:re_editor/re_editor.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/shared/common/button.dart';

class NotesScreen extends StatefulWidget {
  final PageController pageController;

  const NotesScreen({Key? key, required this.pageController}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  late FocusNode textFocusNode;
  // late TextEditingController textEditingController;
  late CodeLineEditingController codeEditingController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    codeEditingController = CodeLineEditingController.fromText(''); // Properly initialize with default text
    textFocusNode.addListener(() {
      if (!textFocusNode.hasFocus) {
        _saveComment();
      }
    });
    codeEditingController.addListener(_onTextChanged); // Add listener
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the active debounce timer if it exists
    textFocusNode.dispose(); // Dispose of the FocusNode
    // textEditingController.removeListener(_onTextChanged); // Remove the text change listener
    // textEditingController.dispose(); // Dispose of the TextEditingController
    codeEditingController.removeListener(_onTextChanged);
    codeEditingController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _saveComment);
  }

  void _saveComment() {
    final String currentText = codeEditingController.text;
    // Check if the text has actually changed to avoid unnecessary updates
    final currentMoodLog = StoreProvider.of<AppState>(context).state.moodEditorState.currentMoodLog;
    if (currentMoodLog?.comment != currentText) {
      final store = StoreProvider.of<AppState>(context);
      final currentMoodLogId = store.state.moodEditorState.currentMoodLog!.id;

      // Update the stored comment without disrupting the editing state
      store.dispatch(UpdateMoodLogCommentAction(currentMoodLogId, currentText));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      child: StoreConnector<AppState, NotesScreenModel>(
        converter: (store) => NotesScreenModel.fromStore(store),
        distinct: true,
        builder: (context, viewModel) {
          if (codeEditingController.text.isEmpty && viewModel.comment != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              codeEditingController.text = viewModel.comment!;
            });
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
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        key: const Key('codeEditorKey'),
                        height: 300, // Specify the height explicitly
                        child: CodeEditor(
                          controller: codeEditingController,
                          // Other configurations for CodeEditor
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'Attachments',
                      //     style: Theme.of(context).textTheme.titleLarge,
                      //   ),
                      // ),
                      // _buildAttachmentsList(viewModel.moodLogId, context),
                    ],
                  ),
                ),
                Container(
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
}

class NotesScreenModel {
  final String moodLogId;
  final String? comment;
  final int currentPageIndex;

  NotesScreenModel({
    required this.moodLogId,
    this.comment,
    required this.currentPageIndex,
  });

  static NotesScreenModel fromStore(Store<AppState> store) {
    return NotesScreenModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      comment: store.state.moodEditorState.currentMoodLog?.comment,
      // attachments: store.state.moodEditorState.currentMoodLog?.attachments ??
      //     [], // Fetch attachments from the state
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
    );
  }
}


// Keeping this code for Future reference

  // Widget _buildUploadButton(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () async {
  //       final picker = ImagePicker();
  //       final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //       if (pickedFile != null) {
  //         // Save the image to the app's directory
  //         final String relativePath =
  //             await ImageStorageHelper.saveImagePermanently(pickedFile.path);

  //         // Generate a unique ID for the attachment (ensure you have a method for this)
  //         String attachmentId = Helpers.generateUniqueId();

  //         // Create a new attachment entity with the relative path
  //         MoodLogAttachmentEntity newAttachment = MoodLogAttachmentEntity(
  //           id: attachmentId,
  //           type: 'image',
  //           path: relativePath, // Store the relative path
  //         );

  //         // Dispatch an action to add this attachment
  //         final store = StoreProvider.of<AppState>(context);
  //         store.dispatch(AddAttachmentAction(
  //           moodLogId: store.state.moodEditorState.currentMoodLog!.id,
  //           attachment: newAttachment,
  //         ));
  //       }
  //     },
  //     child: Container(
  //       width: 100,
  //       height: 100,
  //       decoration: BoxDecoration(
  //         color: Colors.grey[200],
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Icon(Icons.add, color: Colors.grey[600]),
  //     ),
  //   );
  // }



  // Widget _buildAttachmentImage(String relativeImagePath) {
  //   return FutureBuilder<File>(
  //     future: ImageStorageHelper.getImage(relativeImagePath),
  //     builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done &&
  //           snapshot.hasData) {
  //         // When the Future is resolved
  //         return Container(
  //           width: 100,
  //           height: 100,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //             image: DecorationImage(
  //               image: FileImage(snapshot.data!),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         );
  //       } else if (snapshot.connectionState == ConnectionState.waiting ||
  //           !snapshot.hasData) {
  //         // While the Future is loading
  //         return Container(
  //           width: 100,
  //           height: 100,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[200], // Placeholder color
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child:
  //               Center(child: CircularProgressIndicator()), // Loading indicator
  //         );
  //       } else {
  //         // If an error occurs
  //         return Container(
  //           width: 100,
  //           height: 100,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[200], // Placeholder color
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(Icons.error), // Error icon
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget _buildAttachmentsList(String moodLogId, BuildContext context) {
  //   return StoreConnector<AppState, List<MoodLogAttachmentEntity>>(
  //     converter: (store) =>
  //         store.state.moodEditorState.currentMoodLog?.attachments ?? [],
  //     distinct: true,
  //     builder: (context, attachments) {
  //       return SizedBox(
  //         height: 120, // Adjust the container height to fit the content
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: attachments.length + 1, // +1 for the upload button
  //           itemBuilder: (BuildContext context, int index) {
  //             if (index == attachments.length) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: _buildUploadButton(context),
  //               );
  //             }
  //             MoodLogAttachmentEntity attachment = attachments[index];
  //             return Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Stack(
  //                 children: [
  //                   _buildAttachmentImage(
  //                       attachment.path), // Refactor to use FutureBuilder
  //                   Positioned(
  //                     right: 0,
  //                     top: 0,
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         final store = StoreProvider.of<AppState>(context);
  //                         store.dispatch(RemoveAttachmentAction(
  //                           moodLogId: moodLogId,
  //                           attachmentId: attachment.id,
  //                         ));
  //                       },
  //                       child:
  //                           const Icon(Icons.remove_circle, color: Colors.red),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }