import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/presentation/mood/ui/mood_selection_component.dart'; // Import MoodSelectionComponent

class MoodInitialPage extends StatefulWidget {
  final PageController controller;

  const MoodInitialPage({Key? key, required this.controller}) : super(key: key);

  @override
  MoodInitialPageState createState() => MoodInitialPageState();
}

class MoodInitialPageState extends State<MoodInitialPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Fetch the current mood log details
    final currentMoodLog = StoreProvider.of<AppState>(context).state.moodEditorState.currentMoodLog;
    final currentMoodRating = currentMoodLog?.moodRating;
    final currentMoodLogId = currentMoodLog?.id;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How are you feeling?',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          MoodSelectionComponent(
            initialMood: currentMoodRating,
            onMoodSelected: (int moodIndex) {
              final store = StoreProvider.of<AppState>(context);
              if (currentMoodLogId != null) {
                // Dispatch action to update existing mood log
                store.dispatch(TriggerSelectMoodAction(moodIndex, currentMoodLogId));
              } else {
                // Dispatch action to create new mood log
                store.dispatch(TriggerSelectMoodAction(moodIndex));
              }
              store.dispatch(const ChangePageAction(1));
            },
          ),
        ],
      ),
    );
  }
}
