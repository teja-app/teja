import 'package:redux/redux.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_actions.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_state.dart';

Reducer<YearlySleepReportState> yearlySleepReportReducer =
    combineReducers<YearlySleepReportState>([
  TypedReducer<YearlySleepReportState, YearlySleepReportFetchInProgressAction>(
      _yearlyFetchInProgress),
  TypedReducer<YearlySleepReportState, YearlySleepReportFetchedSuccessAction>(
      _yearlyFetchedSuccess),
  TypedReducer<YearlySleepReportState, YearlySleepReportFetchFailedAction>(
      _yearlyFetchFailed),
]);

YearlySleepReportState _yearlyFetchInProgress(YearlySleepReportState state,
    YearlySleepReportFetchInProgressAction action) {
  return state.copyWith(isLoading: true);
}

YearlySleepReportState _yearlyFetchedSuccess(YearlySleepReportState state,
    YearlySleepReportFetchedSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    yearlySleepData: action.yearlySleepData,
    checklist: action.checklist,
    errorMessage: null,
  );
}

YearlySleepReportState _yearlyFetchFailed(
    YearlySleepReportState state, YearlySleepReportFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
