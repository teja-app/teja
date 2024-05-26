import 'package:redux/redux.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_state.dart';

Reducer<MonthlyMoodReportState> monthlyMoodReportReducer =
    combineReducers<MonthlyMoodReportState>([
  TypedReducer<MonthlyMoodReportState, MonthlyMoodReportFetchInProgressAction>(
      _monthlyFetchInProgress),
  TypedReducer<MonthlyMoodReportState, MonthlyMoodReportFetchedSuccessAction>(
      _monthlyFetchedSuccess),
  TypedReducer<MonthlyMoodReportState, MonthlyMoodReportFetchFailedAction>(
      _monthlyFetchFailed),
]);

MonthlyMoodReportState _monthlyFetchInProgress(MonthlyMoodReportState state,
    MonthlyMoodReportFetchInProgressAction action) {
  return state.copyWith(isLoading: true);
}

MonthlyMoodReportState _monthlyFetchedSuccess(MonthlyMoodReportState state,
    MonthlyMoodReportFetchedSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    currentMonthAverageMoodRatings: action.currentMonthAverageMoodRatings,
    errorMessage: null,
    scatterSpots: action.scatterSpots,
  );
}

MonthlyMoodReportState _monthlyFetchFailed(
    MonthlyMoodReportState state, MonthlyMoodReportFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
