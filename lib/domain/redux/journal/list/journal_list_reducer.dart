import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
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
  List<JournalEntryEntity> updatedJournalEntries = List<JournalEntryEntity>.from(state.journalEntries);

  for (var newEntry in action.journalEntries) {
    final index = updatedJournalEntries.indexWhere((existingEntry) => existingEntry.id == newEntry.id);
    if (index != -1) {
      updatedJournalEntries[index] = newEntry; // Update existing entry with new content
    } else {
      updatedJournalEntries.add(newEntry); // Add new entry if not found
    }
  }

  return state.copyWith(
    isLoading: false,
    journalEntries: updatedJournalEntries,
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
