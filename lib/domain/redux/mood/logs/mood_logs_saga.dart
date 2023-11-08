// lib/domain/redux/mood/mood_logs_saga.dart
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/domain/entities/mood_log.dart' as mood_log_entity;

class MoodLogsSaga {
  final MoodLogRepository moodLogRepository;

  MoodLogsSaga(Isar isar) : moodLogRepository = MoodLogRepository(isar);

  void saga(Store<AppState> store, dynamic action) {
    if (action is FetchMoodLogsAction) {
      _fetchMoodLogs(store);
    }
  }

  Future<void> _fetchMoodLogs(Store<AppState> store) async {
    try {
      store.dispatch(FetchMoodLogsAction());

      // Define the range you want to fetch the logs for.
      // This could be dynamic based on the action's payload if needed.
      final DateTime now = DateTime.now();
      final DateTime startOfMonth = DateTime(now.year, now.month);
      final DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

      final moodLogs = await moodLogRepository.getMoodLogsInDateRange(
          startOfMonth, endOfMonth);
      // print("moodLogs ${moodLogs.length}");
      // Transform the List<MoodLog> into the desired Map<DateTime, MoodLog>
      final Map<DateTime, mood_log_entity.MoodLog> moodLogsMap = {
        for (var moodLog in moodLogs)
          moodLog.timestamp: mood_log_entity.MoodLog(
            id: moodLog.id,
            timestamp: moodLog.timestamp,
            moodRating: moodLog.moodRating,
            feelings: [],
            comment: moodLog.comment ?? "",
          )
      };

      store.dispatch(FetchMoodLogsSuccessAction(moodLogsMap));
    } catch (e) {
      store.dispatch(FetchMoodLogsErrorAction(e.toString()));
    }
  }
}
