import 'package:redux/redux.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_actions.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_state.dart';

Reducer<ProfilePageState> profilePageReducer =
    combineReducers<ProfilePageState>([
  TypedReducer<ProfilePageState, ChartSequenceFetchInProgressAction>(
      _chartSequenceFetchInProgress),
  TypedReducer<ProfilePageState, ChartSequenceFetchSuccessAction>(
      _chartSequenceFetchSuccess),
  TypedReducer<ProfilePageState, ChartSequenceFetchFailedAction>(
      _chartSequenceFetchFailed),
  TypedReducer<ProfilePageState, UpdateChartSequenceAction>(
      _updateChartSequence),
]);

ProfilePageState _chartSequenceFetchInProgress(ProfilePageState state,
    ChartSequenceFetchInProgressAction action) {
  return state.copyWith(isLoading: true);
}

ProfilePageState _chartSequenceFetchSuccess(ProfilePageState state,
    ChartSequenceFetchSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    chartSequence: action.chartSequence,
    errorMessage: null,
  );
}

ProfilePageState _chartSequenceFetchFailed(
    ProfilePageState state, ChartSequenceFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}

ProfilePageState _updateChartSequence(
    ProfilePageState state, UpdateChartSequenceAction action) {
  return state.copyWith(
    chartSequence: action.chartSequence,
  );
}
