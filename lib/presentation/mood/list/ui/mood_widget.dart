import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/router.dart';

Widget moodLogLayout(MoodLogEntity moodLog, BuildContext context) {
  final svgPath = 'assets/icons/mood_${moodLog.moodRating}_active.svg';
  final hasComments = moodLog.comment != null ? true : false;
  final tags = [];
  final hasTags = tags.isNotEmpty;
  final textTheme = Theme.of(context).textTheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          // Assuming moodLog.id contains the unique identifier for the mood entry
          final moodId = moodLog.id.toString();
          // Use GoRouter to navigate to the MoodDetailPage

          HapticFeedback.selectionClick();
          GoRouter.of(context).pushNamed(
            RootPath.moodDetail,
            queryParameters: {
              "id": moodId,
            },
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content:
                    const Text('Are you sure you want to delete this entry?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      // Dispatch the Redux action to delete the mood log entry
                      StoreProvider.of<AppState>(context).dispatch(
                          DeleteMoodDetailAction(moodLog.id.toString()));
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
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
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      "${moodLog.moodRating}/5",
                      style: textTheme.titleSmall,
                    ),
                    const Spacer(), // Pushes the timestamp to the right
                    Text(
                      DateFormat('MMM d hh:mm a').format(moodLog
                          .timestamp), // Formats the timestamp to show time only
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                if (hasComments || hasTags) const SizedBox(height: 8),
                if (hasComments)
                  Text(
                    moodLog.comment!,
                    style: const TextStyle(color: Colors.black),
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
    ],
  );
}
