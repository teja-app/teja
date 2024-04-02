import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
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

    return Center(
      child: StoreConnector<AppState, MoodEditorViewModel>(
        converter: MoodEditorViewModel.fromStore,
        builder: (context, viewModel) {
          final currentMoodRating = viewModel.currentMoodLog?.moodRating;
          final currentMoodLogId = viewModel.currentMoodLog?.id;

          return Column(
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
                    // Update of mood
                    store.dispatch(
                      TriggerSelectMoodAction(
                        moodRating: moodIndex,
                        moodLogId: currentMoodLogId,
                      ),
                    );
                  } else {
                    // Create of mood
                    store.dispatch(
                      TriggerSelectMoodAction(
                        moodRating: moodIndex,
                        timestamp: viewModel.selectedDate,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class MoodEditorViewModel {
  final MoodLogEntity? currentMoodLog;
  final DateTime? selectedDate;

  MoodEditorViewModel({this.currentMoodLog, this.selectedDate});

  static MoodEditorViewModel fromStore(Store<AppState> store) {
    return MoodEditorViewModel(
      currentMoodLog: store.state.moodEditorState.currentMoodLog,
      selectedDate: store.state.homeState.selectedDate,
    );
  }
}
