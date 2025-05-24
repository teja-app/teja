import 'package:cbl/cbl.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/domain/redux/mood/mood_sync/mood_sync_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/database/cbl_collections/mood_log.dart' as cbl;

class MoodDetailSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_loadMoodDetail, pattern: LoadMoodDetailAction);
    yield TakeEvery(_deleteMoodDetail, pattern: DeleteMoodDetailAction);
  }

  _loadMoodDetail({required LoadMoodDetailAction action}) sync* {
    var cblResult = Result<Database>();
    yield GetContext('cbl', result: cblResult);
    Database database = cblResult.value!;

    var moodLogRepository = MoodLogRepository(database);
    yield Try(() sync* {
      var moodLog = Result<cbl.MoodLog?>();
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
      yield Put(const SyncMoodLogs());
    }, Catch: (e, s) sync* {
      yield Put(LoadMoodDetailFailureAction(e.toString()));
    });
  }

  _deleteMoodDetail({required DeleteMoodDetailAction action}) sync* {
    var cblResult = Result<Database>();
    yield GetContext('cbl', result: cblResult);
    Database database = cblResult.value!;

    var moodLogRepository = MoodLogRepository(database);

    yield Try(() sync* {
      yield Call(moodLogRepository.deleteMoodLogById, args: [action.moodId]);
      yield Put(const DeleteMoodDetailSuccessAction());
      yield Put(const SyncMoodLogs());
      yield Put(FetchMoodLogsAction());
    }, Catch: (e, s) sync* {
      yield Put(DeleteMoodDetailFailureAction(e.toString()));
      yield Put(FetchMoodLogsAction());
    });
  }
}