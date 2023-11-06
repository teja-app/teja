// lib/domain/redux/mood/mood_editor_saga.dart
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/mood_editor_actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';

class MoodEditorSaga {
  final MoodLogRepository moodLogRepository;

  // Pass the Isar instance to the saga which then creates the repository
  MoodEditorSaga(Isar isar) : moodLogRepository = MoodLogRepository(isar);

  void saga(Store<AppState> store, dynamic action) {
    if (action is SelectMoodAction) {
      _handleSelectMoodAction(action, store);
    } else if (action is GetTodayMoodAction) {
      _getTodayMood(action, store);
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
    }).catchError((error) {
      print("moodLogRepository::errror ${error.toString()}");
      // Dispatch an action that the update has failed with the error message
      store.dispatch(MoodUpdateFailedAction(error.toString()));
    });
  }

  void _getTodayMood(GetTodayMoodAction action, Store<AppState> store) {
    final MoodLog moodLog = moodLogRepository.getTodaysMoodLog() as MoodLog;
    print("moodLog ${moodLog.moodRating}");
  }
}
