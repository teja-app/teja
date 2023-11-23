import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/list/actions.dart';
import 'package:swayam/domain/redux/mood/list/state.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';

class MoodLogListSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchMoodLogs, pattern: LoadMoodLogsListAction);
    yield TakeEvery(_fetchFilteredMoodLogs, pattern: ApplyMoodLogsFilterAction);
    // Add other TakeEvery or TakeLatest for delete, update, etc.
  }

  _fetchFilteredMoodLogs({required ApplyMoodLogsFilterAction action}) sync* {
    yield Put(LoadMoodLogsListAction(0, 10));
  }

  _fetchMoodLogs({required LoadMoodLogsListAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var filterResult = Result<MoodLogFilter>();
      yield Select(
        selector: (AppState state) => state.moodLogListState.filter,
        result: filterResult,
      );

      var moodLogsResult = Result<List<MoodLogEntity>>();
      yield Call(MoodLogRepository(isar).getMoodLogsPage,
          args: [action.pageKey, action.pageSize, filterResult.value],
          result: moodLogsResult);

      if (moodLogsResult.value != null) {
        bool isLastPage = moodLogsResult.value!.length < action.pageSize;
        yield Put(MoodLogsListFetchedSuccessAction(
            moodLogsResult.value!, isLastPage));
      } else {
        yield Put(MoodLogsListFetchFailedAction(
            'No mood logs found for the requested page.'));
      }
    }, Catch: (e, s) sync* {
      print("e.toString() ${e.toString()}");
      print("s ${s}");
      yield Put(MoodLogsListFetchFailedAction(e.toString()));
    });
  }
}
