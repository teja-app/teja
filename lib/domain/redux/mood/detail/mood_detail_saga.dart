import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart' as mood_collection;

class MoodDetailSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_loadMoodDetail, pattern: LoadMoodDetailAction);
    yield TakeEvery(_deleteMoodDetail, pattern: DeleteMoodDetailAction);
  }

  _loadMoodDetail({required LoadMoodDetailAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    yield Try(() sync* {
      var moodLog = Result<mood_collection.MoodLog?>();
      yield Call(
        moodLogRepository.getMoodLogById,
        args: [action.moodId],
        result: moodLog,
      );

      if (moodLog.value != null) {
        yield Put(LoadMoodDetailSuccessAction(moodLogRepository.toEntity(moodLog.value!)));
      } else {
        yield Put(const LoadMoodDetailFailureAction('No mood log found.'));
      }
    }, Catch: (e, s) sync* {
      yield Put(LoadMoodDetailFailureAction(e.toString()));
    });
  }

  _deleteMoodDetail({required DeleteMoodDetailAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    yield Try(() sync* {
      yield Call(moodLogRepository.deleteMoodLogById, args: [action.moodId]);
      yield Put(const DeleteMoodDetailSuccessAction());
      yield Put(FetchMoodLogsAction());
    }, Catch: (e, s) sync* {
      yield Put(DeleteMoodDetailFailureAction(e.toString()));
      yield Put(FetchMoodLogsAction());
    });
  }
}
