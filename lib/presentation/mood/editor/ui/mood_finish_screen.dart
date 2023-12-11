import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class FinishScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const FinishScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle headlineStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
        );
    TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 16,
        );

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
                  style: headlineStyle,
                  textAlign: TextAlign.center,
                ),
                SvgPicture.asset(
                  "assets/icons/mood_done.svg",
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'You’ve completed your mood check-in.',
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                // Congratulatory Message
                Text(
                  '“The whole future lies in uncertainty: live immediately.”\n— Seneca',
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                // Congratulatory Message
                Text(
                  'Take a moment to reflect on your day, write down your thoughts and how you can improve tomorrow.',
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(children: [
              // Next Steps or Actions
              Text(
                "What’s next? Consider doing a quick breathing exercise or take a walk to clear your mind.",
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
            ]),
          ),
          FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                // Feedback Prompt
                Text(
                  'Did you enjoy this mood check-in?',
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Dislike Button
                    IconButton(
                      icon: const Icon(AntDesign.like1),
                      onPressed: () => {}, // Handle feedback response
                    ),
                    // Like Button
                    IconButton(
                      icon: const Icon(AntDesign.dislike1),
                      onPressed: () => {}, // Handle feedback response
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Finish Button
                Button(
                  text: 'Skip  & Finish',
                  onPressed: onFinish,
                  buttonType: ButtonType.disabled,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
