import 'package:redux/redux.dart';
import 'package:teja/domain/redux/quotes/quote_action.dart';
import 'package:teja/domain/redux/quotes/quote_state.dart';

Reducer<QuoteState> quoteReducer = combineReducers<QuoteState>([
  TypedReducer<QuoteState, FetchQuotesInProgressAction>(_fetchQuotesInProgress),
  TypedReducer<QuoteState, QuotesFetchedSuccessAction>(_quotesFetchedSuccess),
  TypedReducer<QuoteState, QuotesFetchFailedAction>(_quotesFetchFailed),
  TypedReducer<QuoteState, QuotesFetchedFromCacheAction>(_quotesFetchedFromCache),
]);

QuoteState _fetchQuotesInProgress(QuoteState state, FetchQuotesInProgressAction action) {
  return state.copyWith(isLoading: true, isFetchSuccessful: false, errorMessage: null);
}

QuoteState _quotesFetchedSuccess(QuoteState state, QuotesFetchedSuccessAction action) {
  return state.copyWith(
    quotes: action.quotes,
    isLoading: false,
    isFetchSuccessful: true,
    lastUpdatedAt: action.lastUpdatedAt,
    errorMessage: null,
  );
}

QuoteState _quotesFetchFailed(QuoteState state, QuotesFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    isFetchSuccessful: false,
    errorMessage: action.error,
  );
}

QuoteState _quotesFetchedFromCache(QuoteState state, QuotesFetchedFromCacheAction action) {
  return state.copyWith(
    quotes: action.quotes,
    isLoading: false,
    errorMessage: null,
    // Note: lastUpdatedAt is not updated for cache fetches
  );
}
