import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:teja/infrastructure/utils/image_storage_helper.dart';
import 'package:teja/infrastructure/utils/video_storage_helper.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_page.model.dart';
import 'package:teja/shared/common/button.dart';

Future<void> selectMedia(JournalQuestionViewModel viewModel, ImagePicker picker) async {
  final List<XFile> mediaFiles = await picker.pickMultipleMedia();

  if (mediaFiles.isNotEmpty) {
    for (XFile file in mediaFiles) {
      print("Media Path: ${file.path}");
      handleMediaType(file, viewModel);
    }
  } else {
    print("No media selected.");
  }
}

Future<void> recordVideo(JournalQuestionViewModel viewModel, ImagePicker picker) async {
  final XFile? video = await picker.pickVideo(source: ImageSource.camera);
  if (video != null) {
    // Handle the video file
    print("Video Path: ${video.path}");
    handleMediaType(video, viewModel);
  }
}

Widget buildBottomActionBar(
    BuildContext context, JournalQuestionViewModel viewModel, ImagePicker picker, void Function() onNext) {
  return BottomActionBar(
    onSelectMedia: () => selectMedia(viewModel, picker),
    onRecordVideo: () => recordVideo(viewModel, picker),
    onNext: onNext,
  );
}

class BottomActionBar extends StatelessWidget {
  final VoidCallback onSelectMedia;
  final VoidCallback onRecordVideo;
  final VoidCallback onNext;

  const BottomActionBar({
    Key? key,
    required this.onSelectMedia,
    required this.onRecordVideo,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white),
            onPressed: onSelectMedia,
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white),
            onPressed: onRecordVideo,
          ),
          Button(
            text: "Next",
            icon: Icons.check,
            onPressed: onNext,
          ),
        ],
      ),
    );
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
