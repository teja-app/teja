import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';
import 'package:teja/domain/entities/mood_log.dart';

class MoodLogsSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchMoodLogs, pattern: FetchMoodLogsAction);
  }

  _fetchMoodLogs({dynamic action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;
    MoodLogRepository moodLogRepository = MoodLogRepository(isar);
    yield Try(() sync* {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month - 5);
      final endOfMonth = DateTime(now.year, now.month + 1, 1);
      var moodLogs = Result<List<MoodLog>>();
      yield Call(moodLogRepository.getMoodLogsInDateRange, args: [startOfMonth, endOfMonth], result: moodLogs);
      if (moodLogs.value == null || moodLogs.value!.isEmpty) {
        yield Put(FetchMoodLogsErrorAction("No mood logs found."));
        return;
      }
      final Map<DateTime, MoodLogEntity> moodLogsMap = {
        for (var moodLog in moodLogs.value!) moodLog.timestamp: moodLogRepository.toEntity(moodLog)
      };

      yield Put(FetchMoodLogsSuccessAction(moodLogsMap));
    }, Catch: (e, s) sync* {
      yield Put(FetchMoodLogsErrorAction(e.toString()));
    });
  }
}
