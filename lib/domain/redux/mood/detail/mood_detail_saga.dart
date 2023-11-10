import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/domain/entities/mood_log.dart' as mood_log_entity;
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart'
    as mood_collection;

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

    try {
      var moodLog = Result<mood_collection.MoodLog?>();
      yield Call(
        moodLogRepository.getMoodLogById,
        args: [action.moodId],
        result: moodLog,
      );

      if (moodLog.value != null) {
        yield Put(LoadMoodDetailSuccessAction(mood_log_entity.MoodLog(
          id: moodLog.value!.id,
          timestamp: moodLog.value!.timestamp,
          moodRating: moodLog.value!.moodRating,
          feelings: [],
          comment: moodLog.value!.comment ?? "",
        )));
      } else {
        yield Put(const LoadMoodDetailFailureAction('No mood log found.'));
      }
    } catch (e) {
      yield Put(LoadMoodDetailFailureAction(e.toString()));
    }
  }

  _deleteMoodDetail({required DeleteMoodDetailAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    try {
      yield Call(moodLogRepository.deleteMoodLogById, args: [action.moodId]);
      yield Put(const DeleteMoodDetailSuccessAction());
      yield Put(FetchMoodLogsAction());
    } catch (e) {
      yield Put(DeleteMoodDetailFailureAction(e.toString()));
      yield Put(FetchMoodLogsAction());
    }
  }
}
