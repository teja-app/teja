import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/domain/redux/mood/list/state.dart';

Reducer<MoodLogListState> moodLogListReducer = combineReducers<MoodLogListState>([
  TypedReducer<MoodLogListState, FetchMoodLogsInProgressAction>(_fetchMoodLogsInProgress),
  TypedReducer<MoodLogListState, MoodLogsListFetchedSuccessAction>(_moodLogsFetchedSuccess),
  TypedReducer<MoodLogListState, MoodLogsListFetchFailedAction>(_moodLogsFetchFailed),
  TypedReducer<MoodLogListState, ResetMoodLogsListAction>(_resetMoodLogsListAction),
  TypedReducer<MoodLogListState, ApplyMoodLogsFilterAction>(_applyMoodLogsFilter),
]);

MoodLogListState _applyMoodLogsFilter(MoodLogListState state, ApplyMoodLogsFilterAction action) {
  return state.copyWith(
    filter: action.filter,
    moodLogs: [], // Reset the mood logs
    isLastPage: false, // Reset pagination
    errorMessage: null, // Clear any existing error message
  );
}

MoodLogListState _fetchMoodLogsInProgress(MoodLogListState state, FetchMoodLogsInProgressAction action) {
  return state.copyWith(isLoading: true);
}

MoodLogListState _resetMoodLogsListAction(MoodLogListState state, ResetMoodLogsListAction action) {
  return state.copyWith(
    isLoading: false,
    moodLogs: [],
    errorMessage: null,
    isLastPage: false,
  );
}

MoodLogListState _moodLogsFetchedSuccess(MoodLogListState state, MoodLogsListFetchedSuccessAction action) {
  List<MoodLogEntity> updatedMoodLogs = List<MoodLogEntity>.from(state.moodLogs);

  for (var newLog in action.moodLogs) {
    final index = updatedMoodLogs.indexWhere((existingLog) => existingLog.id == newLog.id);
    if (index != -1) {
      updatedMoodLogs[index] = newLog; // Update existing log with new content
    } else {
      updatedMoodLogs.add(newLog); // Add new log if not found
    }
  }

  return state.copyWith(
    isLoading: false,
    moodLogs: updatedMoodLogs,
    isLastPage: action.isLastPage,
    errorMessage: null,
  );
}

MoodLogListState _moodLogsFetchFailed(MoodLogListState state, MoodLogsListFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
