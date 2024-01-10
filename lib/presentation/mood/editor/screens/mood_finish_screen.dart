import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:rive/rive.dart';

class FinishScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const FinishScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    void _handleSurveyResponse(BuildContext context, String response) {
      Posthog().capture(
        eventName: 'survey sent',
        properties: {"\$survey_id": "018c81d5-a04a-0000-5b8d-a27f1aa8f6a8", "\$survey_response": response},
      );
      onFinish();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                // Congratulatory Message
                Text(
                  'Good job!',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 200,
                  child: RiveAnimation.asset('assets/mood/perrito.riv'),
                ),
                const SizedBox(height: 20),
                Text(
                  'You’ve completed your mood check-in.',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Feedback Prompt
                Text(
                  'Did you enjoy this mood check-in?',
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
          const SizedBox(height: 50),
          Button(
            text: 'Skip  & Finish',
            onPressed: onFinish,
            buttonType: ButtonType.disabled,
          ),
        ],
      ),
    );
  }
}
