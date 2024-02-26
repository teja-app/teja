import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/router.dart';

Map<String, String> _getMoodEntryText(MoodLogEntity moodLog, BuildContext context) {
  String mainText = '';
  String secondaryText = '';

  // Determine the time of day based on moodLog.timestamp
  String timeOfDay;
  int hour = moodLog.timestamp.hour;
  if (hour >= 5 && hour < 12) {
    timeOfDay = 'in the morning';
  } else if (hour >= 12 && hour < 17) {
    timeOfDay = 'in the afternoon';
  } else if (hour >= 17 && hour < 21) {
    timeOfDay = 'in the evening';
  } else {
    timeOfDay = 'at night';
  }

  if (moodLog.feelings != null && moodLog.feelings!.isNotEmpty) {
    // Main text with the first feeling
    var firstFeeling = moodLog.feelings!.first.feeling;
    mainText = 'Felt $firstFeeling $timeOfDay';

    // Secondary text with additional feelings and factors
    var additionalFeelings = moodLog.feelings!.skip(1).map((e) => e.feeling).toList();
    if (additionalFeelings.isNotEmpty) {
      secondaryText = 'and ${additionalFeelings.join(", ")}';
    }

    // Adding factors to the secondary text if available
    if (moodLog.factors != null && moodLog.factors!.isNotEmpty) {
      String factorsText = moodLog.factors!.join(", ");
      // Append factors to the secondary text
      if (secondaryText.isNotEmpty) {
        secondaryText += ' ';
      }
      secondaryText += 'due to $factorsText';
    }
  } else {
    mainText = 'No Feelings';
  }

  return {
    'mainText': mainText,
    'secondaryText': secondaryText,
  };
}

Widget moodLogLayout(MoodLogEntity moodLog, BuildContext context) {
  final svgPath = 'assets/icons/mood_${moodLog.moodRating}_active.svg';
  final hasComments = moodLog.comment != null ? true : false;
  final tags = [];
  final hasTags = tags.isNotEmpty;
  final textTheme = Theme.of(context).textTheme;

  Map<String, String> moodTexts = _getMoodEntryText(moodLog, context);

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    GestureDetector(
      onTap: () {
        // Assuming moodLog.id contains the unique identifier for the mood entry
        final moodId = moodLog.id.toString();
        HapticFeedback.selectionClick();
        // Use GoRouter to navigate to the MoodDetailPage
        GoRouter.of(context).pushNamed(
          RootPath.moodDetail,
          queryParameters: {
            "id": moodId,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        elevation: 0.5, // Adjusts the elevation for shadow effect
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    svgPath,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    moodTexts['mainText']!,
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('hh:mm a').format(moodLog.timestamp),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              if (moodTexts['secondaryText']!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    moodTexts['secondaryText']!,
                    style: textTheme.labelMedium,
                  ),
                ),
              if (hasComments || hasTags) const SizedBox(height: 8),
              const SizedBox(
                height: 6,
              ),
              if (hasComments)
                Text(
                  moodLog.comment!,
                  style: textTheme.bodySmall,
                ),
              if (hasTags) const SizedBox(height: 16),
              if (hasTags)
                Wrap(
                  spacing: 8,
                  children: tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
              if (moodLog.attachments != null && moodLog.attachments!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 100, // Height for the horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: moodLog.attachments!.length,
                      itemBuilder: (context, index) {
                        var attachment = moodLog.attachments![index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: AttachmentImage(
                            relativeImagePath: attachment.path,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  ]);
}
