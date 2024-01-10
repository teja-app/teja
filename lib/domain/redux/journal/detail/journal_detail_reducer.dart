import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_state.dart';

JournalDetailState journalDetailReducer(JournalDetailState state, dynamic action) {
  if (action is LoadJournalDetailAction) {
    return _loadJournalDetail(state, action);
  } else if (action is LoadJournalDetailSuccessAction) {
    return _setJournalDetail(state, action);
  } else if (action is LoadJournalDetailFailureAction) {
    return _journalDetailError(state, action);
  } else if (action is DeleteJournalDetailAction) {
    return _deleteJournalDetail(state, action);
  } else if (action is DeleteJournalDetailSuccessAction) {
    return _deleteJournalDetailSuccess(state, action);
  } else if (action is DeleteJournalDetailFailureAction) {
    return _deleteJournalDetailError(state, action);
  }
  return state;
}

JournalDetailState _loadJournalDetail(JournalDetailState state, LoadJournalDetailAction action) {
  return state.copyWith(isLoading: true, errorMessage: null);
}

JournalDetailState _setJournalDetail(JournalDetailState state, LoadJournalDetailSuccessAction action) {
  return state.copyWith(selectedJournalEntry: action.journalEntry, isLoading: false, errorMessage: null);
}

JournalDetailState _journalDetailError(JournalDetailState state, LoadJournalDetailFailureAction action) {
  return state.copyWith(isLoading: false, errorMessage: action.errorMessage);
}

JournalDetailState _deleteJournalDetail(JournalDetailState state, DeleteJournalDetailAction action) {
  // You can handle a loading state here if needed
  return state;
}

JournalDetailState _deleteJournalDetailSuccess(JournalDetailState state, DeleteJournalDetailSuccessAction action) {
  return JournalDetailState.initialState();
}

JournalDetailState _deleteJournalDetailError(JournalDetailState state, DeleteJournalDetailFailureAction action) {
  return state.copyWith(errorMessage: action.errorMessage);
}
