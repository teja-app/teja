import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/mood/list/actions.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';

class MoodLogListSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchMoodLogs, pattern: LoadMoodLogsListAction);
    // Add other TakeEvery or TakeLatest for delete, update, etc.
  }

  _fetchMoodLogs({required LoadMoodLogsListAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    try {
      var moodLogsResult = Result<List<MoodLogEntity>>();
      yield Call(MoodLogRepository(isar).getMoodLogsPage,
          args: [action.pageKey, action.pageSize], result: moodLogsResult);

      if (moodLogsResult.value != null) {
        bool isLastPage = moodLogsResult.value!.length < action.pageSize;
        yield Put(MoodLogsListFetchedSuccessAction(
            moodLogsResult.value!, isLastPage));
      } else {
        yield Put(MoodLogsListFetchFailedAction(
            'No mood logs found for the requested page.'));
      }
    } catch (e) {
      yield Put(MoodLogsListFetchFailedAction(e.toString()));
    }
  }
}
