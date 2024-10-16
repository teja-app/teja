import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_state.dart';

final Reducer<MoodLogsState> moodLogsReducer = combineReducers<MoodLogsState>([
  TypedReducer<MoodLogsState, FetchMoodLogsAction>(_fetchMoodLogs),
  TypedReducer<MoodLogsState, FetchMoodLogsSuccessAction>(_fetchMoodLogsSuccess),
  TypedReducer<MoodLogsState, FetchMoodLogsErrorAction>(_fetchMoodLogsError),
  // ... add other TypedReducers for different actions as needed
]);

MoodLogsState _fetchMoodLogs(MoodLogsState state, FetchMoodLogsAction action) {
  return state.copyWith(isFetching: true);
}

MoodLogsState _fetchMoodLogsSuccess(MoodLogsState state, FetchMoodLogsSuccessAction action) {
  // Convert Map<DateTime, List<MoodLogEntity>> to Map<String, List<MoodLogEntity>>
  Map<String, List<MoodLogEntity>> stringKeyedMap = action.moodLogs.map((key, value) {
    return MapEntry(DateFormat('yyyy-MM-dd').format(key), value);
  });

  return state.copyWith(
    moodLogsByDate: stringKeyedMap,
    isFetching: false,
    fetchSuccess: true,
  );
}

MoodLogsState _fetchMoodLogsError(MoodLogsState state, FetchMoodLogsErrorAction action) {
  return state.copyWith(
    moodLogsByDate: const {},
    isFetching: false,
    errorMessage: action.errorMessage,
  );
}
