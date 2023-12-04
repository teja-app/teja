// Reducer for MasterFactors
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/domain/redux/mood/master_factor/state.dart';

Reducer<MasterFactorState> masterFactorReducer = combineReducers<MasterFactorState>([
  TypedReducer<MasterFactorState, FetchMasterFactorsInProgressAction>(_fetchMasterFactorsInProgress),
  TypedReducer<MasterFactorState, MasterFactorsFetchedSuccessAction>(_masterFactorsFetchedSuccess),
  TypedReducer<MasterFactorState, MasterFactorsFetchFailedAction>(_masterFactorsFetchFailed),
  TypedReducer<MasterFactorState, MasterFactorsFetchedFromCacheAction>(_masterFactorsFetchedFromCache),
]);

MasterFactorState _fetchMasterFactorsInProgress(MasterFactorState state, FetchMasterFactorsInProgressAction action) {
  return state.copyWith(isLoading: true, isFetchSuccessful: false, errorMessage: null);
}

MasterFactorState _masterFactorsFetchedSuccess(MasterFactorState state, MasterFactorsFetchedSuccessAction action) {
  return state.copyWith(
    masterFactors: action.factors,
    isLoading: false,
    isFetchSuccessful: true,
    lastUpdatedAt: action.lastUpdatedAt,
    errorMessage: null,
  );
}

MasterFactorState _masterFactorsFetchFailed(MasterFactorState state, MasterFactorsFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    isFetchSuccessful: false,
    errorMessage: action.error,
  );
}

MasterFactorState _masterFactorsFetchedFromCache(MasterFactorState state, MasterFactorsFetchedFromCacheAction action) {
  return state.copyWith(
    masterFactors: action.factors,
    isLoading: false,
    errorMessage: null,
    // Note: lastUpdatedAt is not updated for cache fetches
  );
}
