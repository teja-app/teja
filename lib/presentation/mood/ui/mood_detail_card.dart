import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/router.dart';

Widget _getMoodEntryText(MoodLogEntity moodLog, BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  if (moodLog.feelings != null && moodLog.feelings!.isNotEmpty) {
    String feelingsText;
    int feelingsCount = moodLog.feelings!.length;
    if (feelingsCount > 2) {
      // Get the first feeling and append 'and X more feelings'
      var firstFeeling = moodLog.feelings!.first.feeling;
      feelingsText = '$firstFeeling and ${feelingsCount - 1} more feelings';
    } else if (feelingsCount == 2) {
      // Directly join the two feelings with 'and'
      feelingsText = moodLog.feelings!.map((e) => e.feeling).join(' and ');
    } else {
      // If only one feeling, display it directly
      feelingsText = moodLog.feelings!.map((e) => e.feeling).join(', ');
    }

    return Text(
      feelingsText,
      style: textTheme.titleMedium,
    );
  } else {
    return Text(
      'No Feelings',
      style: textTheme.titleMedium,
    );
  }
}

Widget moodLogLayout(MoodLogEntity moodLog, BuildContext context) {
  final svgPath = 'assets/icons/mood_${moodLog.moodRating}_active.svg';
  final hasComments = moodLog.comment != null ? true : false;
  final tags = [];
  final hasTags = tags.isNotEmpty;
  final textTheme = Theme.of(context).textTheme;

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
                  _getMoodEntryText(moodLog, context),
                  const Spacer(),
                  Text(
                    DateFormat('hh:mm a').format(moodLog.timestamp),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              if (hasComments || hasTags) const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    ),
  ]);
}
