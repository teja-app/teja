// lib/domain/redux/mood/master_feeling/reducer.dart

import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/mood/master_feeling/state.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';

// Main reducer for master feelings
Reducer<MasterFeelingState> masterFeelingReducer =
    combineReducers<MasterFeelingState>([
  TypedReducer<MasterFeelingState, FetchMasterFeelingsInProgressAction>(
      _fetchMasterFeelingsInProgress),
  TypedReducer<MasterFeelingState, MasterFeelingsFetchedAction>(
      _masterFeelingsFetched),
  TypedReducer<MasterFeelingState, MasterFeelingsFetchFailedAction>(
      _masterFeelingsFetchFailed),
]);

// Handle fetch in progress action
MasterFeelingState _fetchMasterFeelingsInProgress(
    MasterFeelingState state, FetchMasterFeelingsInProgressAction action) {
  return state.copyWith(isLoading: true);
}

// Handle fetched master feelings action
MasterFeelingState _masterFeelingsFetched(
    MasterFeelingState state, MasterFeelingsFetchedAction action) {
  return state.copyWith(
    masterFeelings: action.feelings,
    isLoading: false,
    errorMessage: null,
  );
}

// Handle fetch failed action
MasterFeelingState _masterFeelingsFetchFailed(
    MasterFeelingState state, MasterFeelingsFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.error,
  );
}
