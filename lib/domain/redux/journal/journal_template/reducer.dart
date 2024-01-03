import 'package:redux/redux.dart';
import 'package:teja/domain/redux/journal/journal_template/actions.dart';
import 'package:teja/domain/redux/journal/journal_template/state.dart';

Reducer<JournalTemplateState> journalTemplateReducer = combineReducers<JournalTemplateState>([
  TypedReducer<JournalTemplateState, FetchJournalTemplatesInProgressAction>(_fetchJournalTemplatesInProgress),
  TypedReducer<JournalTemplateState, JournalTemplatesFetchedSuccessAction>(_journalTemplatesFetchedSuccess),
  TypedReducer<JournalTemplateState, JournalTemplatesFetchFailedAction>(_journalTemplatesFetchFailed),
  TypedReducer<JournalTemplateState, JournalTemplatesFetchedFromCacheAction>(_journalTemplatesFetchedFromCache),
]);

JournalTemplateState _fetchJournalTemplatesInProgress(
    JournalTemplateState state, FetchJournalTemplatesInProgressAction action) {
  return state.copyWith(isLoading: true, isFetchSuccessful: false, errorMessage: null);
}

JournalTemplateState _journalTemplatesFetchedSuccess(
    JournalTemplateState state, JournalTemplatesFetchedSuccessAction action) {
  return state.copyWith(
    templates: action.templates,
    isLoading: false,
    isFetchSuccessful: true,
    lastUpdatedAt: action.lastUpdatedAt,
    errorMessage: null,
  );
}

JournalTemplateState _journalTemplatesFetchFailed(
    JournalTemplateState state, JournalTemplatesFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    isFetchSuccessful: false,
    errorMessage: action.error,
  );
}

JournalTemplateState _journalTemplatesFetchedFromCache(
    JournalTemplateState state, JournalTemplatesFetchedFromCacheAction action) {
  return state.copyWith(
    templates: action.templates,
    isLoading: false,
    isFetchSuccessful: true,
    updateErrorMessage: null,
    errorMessage: null,
    // lastUpdatedAt is not updated for cache fetches
  );
}
