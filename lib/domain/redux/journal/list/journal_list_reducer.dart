import 'package:redux/redux.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_state.dart';

Reducer<JournalListState> journalListReducer = combineReducers<JournalListState>([
  TypedReducer<JournalListState, FetchJournalEntriesInProgressAction>(_fetchJournalEntriesInProgress),
  TypedReducer<JournalListState, JournalEntriesListFetchedSuccessAction>(_journalEntriesFetchedSuccess),
  TypedReducer<JournalListState, JournalEntriesListFetchFailedAction>(_journalEntriesFetchFailed),
  TypedReducer<JournalListState, ResetJournalEntriesListAction>(_resetJournalEntriesList),
]);

JournalListState _fetchJournalEntriesInProgress(JournalListState state, FetchJournalEntriesInProgressAction action) {
  return state.copyWith(isLoading: true);
}

JournalListState _resetJournalEntriesList(JournalListState state, ResetJournalEntriesListAction action) {
  return state.copyWith(
    isLoading: false,
    journalEntries: [],
    errorMessage: null,
    isLastPage: false,
  );
}

JournalListState _journalEntriesFetchedSuccess(JournalListState state, JournalEntriesListFetchedSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    journalEntries: [...state.journalEntries, ...action.journalEntries],
    isLastPage: action.isLastPage,
    errorMessage: null,
  );
}

JournalListState _journalEntriesFetchFailed(JournalListState state, JournalEntriesListFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}
