import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/weekly_mood_report/weekly_mood_report_actions.dart';
import 'package:swayam/domain/redux/weekly_mood_report/weekly_mood_report_state.dart';

Reducer<WeeklyMoodReportState> weeklyMoodReportReducer =
    combineReducers<WeeklyMoodReportState>([
  TypedReducer<WeeklyMoodReportState, WeeklyMoodReportFetchInProgressAction>(
      _fetchInProgress),
  TypedReducer<WeeklyMoodReportState, WeeklyMoodReportFetchedSuccessAction>(
      _fetchedSuccess),
  TypedReducer<WeeklyMoodReportState, WeeklyMoodReportFetchFailedAction>(
      _fetchFailed),
]);

WeeklyMoodReportState _fetchInProgress(
    WeeklyMoodReportState state, WeeklyMoodReportFetchInProgressAction action) {
  return state.copyWith(isLoading: true);
}

WeeklyMoodReportState _fetchedSuccess(
    WeeklyMoodReportState state, WeeklyMoodReportFetchedSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    currentWeekAverageMoodRatings: action.currentWeekAverageMoodRatings,
    previousWeekAverageMoodRatings: action.previousWeekAverageMoodRatings,
    errorMessage: null,
  );
}

WeeklyMoodReportState _fetchFailed(
    WeeklyMoodReportState state, WeeklyMoodReportFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
