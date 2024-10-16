import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/mood/detail/ui/buttons/ai_suggestion_button.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:rive/rive.dart';
import 'package:teja/theme/padding.dart';
import 'package:in_app_review/in_app_review.dart';

class FinishScreenModel {
  final int moodRating;
  final MoodLogEntity? currentMoodLog;

  FinishScreenModel({
    required this.moodRating,
    this.currentMoodLog,
  }); // +2 for initial and feeling pages

  static FinishScreenModel fromStore(Store<AppState> store) {
    return FinishScreenModel(
      currentMoodLog: store.state.moodEditorState.currentMoodLog,
      moodRating: store.state.moodEditorState.currentMoodLog!.moodRating,
    );
  }
}

class FinishScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const FinishScreen({Key? key, required this.onFinish}) : super(key: key); // Modify this line

  void _triggerAppReview() async {
    if (await InAppReview.instance.isAvailable()) {
      InAppReview.instance.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    void _handleSurveyResponse(BuildContext context, String response) {
      if (response == "Yes") {
        _triggerAppReview();
      }
      Posthog().capture(
        eventName: 'survey sent',
        properties: {"\$survey_id": "018c81d5-a04a-0000-5b8d-a27f1aa8f6a8", "\$survey_response": response},
      );
      onFinish();
    }

    return StoreConnector<AppState, FinishScreenModel>(
      converter: FinishScreenModel.fromStore,
      builder: (context, viewModel) {
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
                    if (viewModel.moodRating >= 4) // Conditional Rendering based on moodRating
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          // Feedback Prompt
                          Text(
                            'How was your experience so far?',
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
                                onPressed: () => {_handleSurveyResponse(context, "Yes")},
                              ),
                              // Like Button
                              IconButton(
                                icon: const Icon(AntDesign.dislike1),
                                onPressed: () => {_handleSurveyResponse(context, "No")},
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Center(
                child: AISuggestionButton(moodId: viewModel.currentMoodLog!.id),
              ),
              const SizedBox(height: smallSpacer),
              Button(
                text: 'Skip  & Finish',
                onPressed: onFinish,
                // buttonType: ButtonType.disabled,
              ),
            ],
          ),
        );
      },
    );
  }
}
