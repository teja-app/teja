// lib/presentation/journal/journal_editor/ui/finish_screen.dart
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:rive/rive.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:in_app_review/in_app_review.dart';

class JournalFinishScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const JournalFinishScreen({Key? key, required this.onFinish}) : super(key: key);

  void _triggerAppReview() async {
    if (await InAppReview.instance.isAvailable()) {
      InAppReview.instance.requestReview();
    }
  }

  void _handleSurveyResponse(BuildContext context, String response) {
    if (response == "Yes") {
      _triggerAppReview();
    }
    Posthog().capture(
      eventName: 'survey sent',
      properties: {"\$survey_id": "018cfeff-21d8-0000-3eae-0df53fb0043f", "\$survey_response": response},
    );
    onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
            child: RiveAnimation.asset('assets/mood/perrito.riv'),
          ),
          const SizedBox(height: 16),
          const Text('Your journal entry has been saved.'),

          const SizedBox(height: 20),
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Feedback Prompt
                Text(
                  'Did you like journaling?',
                  style: textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Dislike Button
                    IconButton(
                      icon: const Icon(AntDesign.like1),
                      onPressed: () => {_handleSurveyResponse(context, "Yes")}, // Handle feedback response
                    ),
                    // Like Button
                    IconButton(
                      icon: const Icon(AntDesign.dislike1),
                      onPressed: () => {_handleSurveyResponse(context, "No")}, // Handle feedback response
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Button(
                text: "Done",
                width: 300,
                onPressed: onFinish,
                buttonType: ButtonType.primary,
              ),
            ),
          ),
          // Button(
          //   onPressed: onFinish,
          //   child: const Text('Return to Journal'),
          // ),
        ],
      ),
    );
  }
}
