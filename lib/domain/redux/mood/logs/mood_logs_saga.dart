import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';
import 'package:swayam/domain/entities/mood_log.dart';

class MoodLogsSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchMoodLogs, pattern: FetchMoodLogsAction);
  }

  _fetchMoodLogs({dynamic action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;
    MoodLogRepository moodLogRepository = MoodLogRepository(isar);
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      var moodLogs = Result<List<MoodLog>>();
      yield Call(moodLogRepository.getMoodLogsInDateRange,
          args: [startOfMonth, endOfMonth], result: moodLogs);
      if (moodLogs.value == null || moodLogs.value!.isEmpty) {
        yield Put(FetchMoodLogsErrorAction("No mood logs found."));
        return;
      }
      final Map<DateTime, MoodLogEntity> moodLogsMap = {
        for (var moodLog in moodLogs.value!)
          moodLog.timestamp: MoodLogEntity(
            id: moodLog.id,
            timestamp: moodLog.timestamp,
            moodRating: moodLog.moodRating,
            feelings: [],
            comment: moodLog.comment ?? "",
          )
      };

      yield Put(FetchMoodLogsSuccessAction(moodLogsMap));
    } catch (e) {
      yield Put(FetchMoodLogsErrorAction(e.toString()));
    }
  }
}
