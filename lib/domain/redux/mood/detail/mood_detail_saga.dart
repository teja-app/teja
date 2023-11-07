// lib/domain/redux/mood/mood_detail_saga.dart
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/domain/entities/mood_log.dart' as mood_log_entity;

class MoodDetailSaga {
  final MoodLogRepository moodLogRepository;

  // Pass the Isar instance to the saga which then creates the repository
  MoodDetailSaga(Isar isar) : moodLogRepository = MoodLogRepository(isar);

  void saga(Store<AppState> store, dynamic action) {
    if (action is LoadMoodDetailAction) {
      _loadMoodDetail(action, store);
    }
  }

  void _loadMoodDetail(
      LoadMoodDetailAction action, Store<AppState> store) async {
    try {
      // Begin by dispatching a loading action.
      store.dispatch(LoadMoodDetailAction(action.moodId));

      // Fetch the mood log details from the repository.
      final moodLog = await moodLogRepository.getMoodLogById(action.moodId);

      if (moodLog != null) {
        // If the mood log exists, dispatch a success action with the data.
        store.dispatch(LoadMoodDetailSuccessAction(mood_log_entity.MoodLog(
          id: moodLog.id,
          timestamp: moodLog.timestamp,
          moodRating: moodLog.moodRating,
          feelings: [],
          comment: moodLog.comment ?? "",
        )));
      } else {
        // If no mood log was found, dispatch an appropriate action or error.
        store.dispatch(LoadMoodDetailFailureAction('No mood log found.'));
      }
    } catch (e) {
      // In case of an error, dispatch a failure action with the error message.
      store.dispatch(LoadMoodDetailFailureAction(e.toString()));
    }
  }
}
