import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/mood/list/actions.dart';
import 'package:swayam/domain/redux/mood/list/state.dart';

Reducer<MoodLogListState> moodLogListReducer =
    combineReducers<MoodLogListState>([
  TypedReducer<MoodLogListState, FetchMoodLogsInProgressAction>(
      _fetchMoodLogsInProgress),
  TypedReducer<MoodLogListState, MoodLogsListFetchedSuccessAction>(
      _moodLogsFetchedSuccess),
  TypedReducer<MoodLogListState, MoodLogsListFetchFailedAction>(
      _moodLogsFetchFailed),
]);

MoodLogListState _fetchMoodLogsInProgress(
    MoodLogListState state, FetchMoodLogsInProgressAction action) {
  return state.copyWith(isLoading: true);
}

MoodLogListState _moodLogsFetchedSuccess(
    MoodLogListState state, MoodLogsListFetchedSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    moodLogs: [...state.moodLogs, ...action.moodLogs],
    isLastPage: action.isLastPage,
    errorMessage: null,
  );
}

MoodLogListState _moodLogsFetchFailed(
    MoodLogListState state, MoodLogsListFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
