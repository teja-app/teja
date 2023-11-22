// lib/domain/redux/mood/master_feeling/reducer.dart

import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/mood/master_feeling/state.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';

// Main reducer for master feelings
Reducer<MasterFeelingState> masterFeelingReducer =
    combineReducers<MasterFeelingState>([
  TypedReducer<MasterFeelingState, FetchMasterFeelingsInProgressAction>(
      _fetchMasterFeelingsInProgress),
  TypedReducer<MasterFeelingState, MasterFeelingsFetchedSuccessAction>(
      _masterFeelingsFetchedSuccess),
  TypedReducer<MasterFeelingState, MasterFeelingsFetchFailedAction>(
      _masterFeelingsFetchFailed),
  TypedReducer<MasterFeelingState, MasterFeelingsFetchedFromCacheAction>(
      _masterFeelingsFetchedFromCache),
]);

// Handle fetch in progress action
MasterFeelingState _fetchMasterFeelingsInProgress(
    MasterFeelingState state, FetchMasterFeelingsInProgressAction action) {
  return state.copyWith(isLoading: true);
}

MasterFeelingState _masterFeelingsFetchedSuccess(
    MasterFeelingState state, MasterFeelingsFetchedSuccessAction action) {
  return state.copyWith(
    masterFeelings: action.feelings,
    isLoading: false,
    errorMessage: null,
    isFetchSuccessful: true,
    lastUpdatedAt: action.lastUpdatedAt,
  );
}

MasterFeelingState _masterFeelingsFetchedFromCache(
    MasterFeelingState state, MasterFeelingsFetchedFromCacheAction action) {
  return state.copyWith(
    masterFeelings: action.feelings,
    isLoading: false,
    errorMessage: null,
    // Don't update lastUpdatedAt for cache fetches
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
