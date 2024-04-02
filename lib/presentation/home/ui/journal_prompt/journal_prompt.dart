import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/presentation/home/ui/journal_prompt/pen_down_button.dart';
import 'package:teja/presentation/home/ui/journal_prompt/track_mood_button.dart';
import 'package:teja/router.dart';

class JournalPrompt extends StatelessWidget {
  const JournalPrompt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text("What would you like to journal?", style: textTheme.titleLarge),
        const SizedBox(height: 20), // Assuming smallSpacer is 20
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PenDownButton(
              onTap: () => goRouter.pushNamed(RootPath.journalCategory),
            ),
            TrackMoodButton(
              onTap: () => goRouter.pushNamed(RootPath.moodEdit),
            ),
          ],
        ),
      ],
    );
  }
}
