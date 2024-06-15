import 'package:redux/redux.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_actions.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_state.dart';

Reducer<YearlyMoodReportState> yearlyMoodReportReducer =
    combineReducers<YearlyMoodReportState>([
  TypedReducer<YearlyMoodReportState, YealryMoodReportFetchInProgressAction>(
      _yearlyFetchInProgress),
  TypedReducer<YearlyMoodReportState, YearlyMoodReportFetchedSuccessAction>(
      _yearlyFetchedSuccess),
  TypedReducer<YearlyMoodReportState, YearlyMoodReportFetchFailedAction>(
      _yearlyFetchFailed),
]);

YearlyMoodReportState _yearlyFetchInProgress(
    YearlyMoodReportState state, YealryMoodReportFetchInProgressAction action) {
  return state.copyWith(isLoading: true);
}

YearlyMoodReportState _yearlyFetchedSuccess(
    YearlyMoodReportState state, YearlyMoodReportFetchedSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    currentYearAverageMoodRatings: action.currentYearAverageMoodRatings,
    errorMessage: null,
  );
}

YearlyMoodReportState _yearlyFetchFailed(
    YearlyMoodReportState state, YearlyMoodReportFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
