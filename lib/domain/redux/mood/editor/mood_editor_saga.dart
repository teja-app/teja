// lib/domain/redux/mood/mood_editor_saga.dart
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';
import 'package:swayam/domain/entities/mood_log.dart' as mood_log_entity;

class MoodEditorSaga {
  final MoodLogRepository moodLogRepository;

  // Pass the Isar instance to the saga which then creates the repository
  MoodEditorSaga(Isar isar) : moodLogRepository = MoodLogRepository(isar);

  void saga(Store<AppState> store, dynamic action) {
    if (action is SelectMoodAction) {
      _handleSelectMoodAction(action, store);
    } else if (action is GetTodayMoodAction) {
      _getCurrentMood(action, store);
    }
  }

  void _handleSelectMoodAction(SelectMoodAction action, Store<AppState> store) {
    // Assuming the moodRating is the only required field for now
    MoodLog moodLog = MoodLog()..moodRating = action.moodRating;

    // Dispatch an action indicating the update process has started
    // store.dispatch(MoodUpdateInProgressAction());

    moodLogRepository.addOrUpdateMoodLog(moodLog).then((_) {
      // Dispatch an action that the mood has been updated successfully
      store.dispatch(MoodUpdatedAction("Successful"));
      store.dispatch(GetTodayMoodAction());
    }).catchError((error) {
      print("moodLogRepository::errror ${error.toString()}");
      // Dispatch an action that the update has failed with the error message
      store.dispatch(MoodUpdateFailedAction(error.toString()));
    });
  }

  void _getCurrentMood(GetTodayMoodAction action, Store<AppState> store) async {
    try {
      // Await the future to get the actual MoodLog object.
      final MoodLog? moodLog = await moodLogRepository.getTodaysMoodLog();

      if (moodLog != null) {
        // Use the moodLog as needed if it is not null.
        print("moodLog ${moodLog.moodRating} ${moodLog.id} ${moodLog.isarId}");
        store.dispatch(
          SetTodayMoodLogAction(
            mood_log_entity.MoodLog(
              id: moodLog.id,
              timestamp: moodLog.timestamp,
              moodRating: moodLog.moodRating,
              comment: moodLog.comment ?? "",
              feelings: [],
            ),
          ),
        );
      } else {
        // Handle the case where no moodLog was found for today.
        print("No mood log found for today.");
        // Optionally, dispatch an action here if you need to update the state.
      }
    } catch (error) {
      // Handle any errors that might occur during the fetch.
      print("Error getting today's mood log: ${error.toString()}");
      // Optionally, dispatch an action here if you need to update the state.
    }
  }
}
