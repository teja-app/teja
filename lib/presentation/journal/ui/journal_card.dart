import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/presentation/mood/ui/attachment_video.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

Widget journalEntryLayout(
  JournalTemplateEntity template,
  JournalEntryEntity journalEntry,
  BuildContext context, {
  double gridWidth = 4, // Optional parameter with default value
}) {
  final textTheme = Theme.of(context).textTheme;
  final firstQuestion = journalEntry.questions?.isNotEmpty == true ? journalEntry.questions!.first : null;

  Widget _buildMediaRow() {
    final images = journalEntry.imageEntries?.take(3).toList() ?? [];
    final videos = journalEntry.videoEntries?.take(3).toList() ?? [];

    if (images.isEmpty && videos.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: 60, // Adjust height accordingly
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + videos.length,
        itemBuilder: (context, index) {
          if (index < images.length) {
            final imagePath = images[index].filePath;
            if (imagePath != null) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: AttachmentImage(
                  relativeImagePath: imagePath,
                  width: 100, // Adjust width as needed
                  height: 50, // Adjust height as needed
                ),
              );
            }
          } else {
            final videoIndex = index - images.length;
            final videoPath = videos[videoIndex].filePath;
            if (videoPath != null) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: AttachmentVideo(
                  relativeVideoPath: videoPath,
                  width: 100, // Adjust width as needed
                  height: 50, // Adjust height as needed
                ),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          GoRouter.of(context).pushNamed(
            RootPath.journalDetail,
            queryParameters: {
              "id": journalEntry.id,
            },
          );
        },
        child: FlexibleHeightBox(
          gridWidth: gridWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.title,
                  style: textTheme.titleMedium,
                ),
                Text(
                  firstQuestion?.questionText ?? 'No question',
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  firstQuestion?.answerText ?? 'No answer',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _buildMediaRow(), // Add the image row here
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('hh:mm a').format(journalEntry.createdAt),
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
