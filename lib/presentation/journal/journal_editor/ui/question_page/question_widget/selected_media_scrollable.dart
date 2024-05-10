import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_page.model.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_widget/media_entry.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/presentation/mood/ui/attachment_video.dart';

Widget buildSelectedMediaScrollable(
  BuildContext context,
  JournalQuestionViewModel viewModel,
) {
  final combinedEntries = [
    if (viewModel.imageEntries != null)
      ...viewModel.imageEntries!.map((entry) => MediaEntry(type: MediaType.image, entry: entry)),
    if (viewModel.videoEntries != null)
      ...viewModel.videoEntries!.map((entry) => MediaEntry(type: MediaType.video, entry: entry)),
  ];

  return Container(
    width: 50,
    height: MediaQuery.of(context).size.height - 200,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: combinedEntries.length,
      itemBuilder: (context, index) {
        final mediaEntry = combinedEntries[index];
        if (mediaEntry.type == MediaType.image) {
          final imageEntry = mediaEntry.entry as ImageEntryEntity;
          return AttachmentImage(
            key: ValueKey(imageEntry.id),
            relativeImagePath: imageEntry.filePath!,
            width: 50,
            height: 30,
          );
        } else {
          final videoEntry = mediaEntry.entry as VideoEntryEntity;
          return AttachmentVideo(
            key: ValueKey(videoEntry.id),
            relativeVideoPath: videoEntry.filePath!,
            width: 50,
            height: 30,
          );
        }
      },
    ),
  );
}
