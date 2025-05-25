import 'package:cbl/cbl.dart' as cbl;
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/domain/redux/mood/list/state.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

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
      var cblResult = Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database database = cblResult.value!;

      var filterResult = Result<MoodLogFilter>();
      yield Select(
        selector: (AppState state) => state.moodLogListState.filter,
        result: filterResult,
      );

      var moodLogsResult = Result<List<MoodLogEntity>>();
      yield Call(MoodLogRepository(database).getMoodLogsPage,
          args: [action.pageKey, action.pageSize, filterResult.value], result: moodLogsResult);

      if (moodLogsResult.value != null) {
        bool isLastPage = moodLogsResult.value!.length < action.pageSize;
        yield Put(MoodLogsListFetchedSuccessAction(moodLogsResult.value!, isLastPage));
      } else {
        yield Put(MoodLogsListFetchFailedAction('No mood logs found for the requested page.'));
      }
    }, Catch: (e, s) sync* {
      yield Put(MoodLogsListFetchFailedAction(e.toString()));
    });
  }
}