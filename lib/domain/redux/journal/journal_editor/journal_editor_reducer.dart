import 'package:redux/redux.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_state.dart';

JournalEditorState _updateJournalEntry(JournalEditorState state, SaveJournalEntry action) {
  return state.copyWith(currentJournalEntry: action.journalEntry);
}

JournalEditorState _updateQuestionAnswer(JournalEditorState state, UpdateQuestionAnswer action) {
  var updatedQuestions = state.currentJournalEntry?.questions?.map((q) {
    if (q.questionId == action.questionId) {
      return q.copyWith(answerText: action.answerText);
    }
    return q;
  }).toList();

  return state.copyWith(currentJournalEntry: state.currentJournalEntry?.copyWith(questions: updatedQuestions));
}

JournalEditorState _clearMoodEditorFormSuccess(JournalEditorState state, ClearJournalEditorSuccess action) {
  return JournalEditorState.initialState();
}

JournalEditorState _initializeJournalEditorSuccess(
    JournalEditorState state, InitializeJournalEditorSuccessAction action) {
  return state.copyWith(currentJournalEntry: action.journalEntry);
}

JournalEditorState _initializeJournalEditorFailure(
    JournalEditorState state, InitializeJournalEditorFailureAction action) {
  return state.copyWith(error: action.error);
}

JournalEditorState _changeJournalPage(JournalEditorState state, ChangeJournalPageAction action) {
  return state.copyWith(currentPageIndex: action.pageIndex);
}

JournalEditorState _addOrUpdateImageFailure(JournalEditorState state, AddOrUpdateImageFailureAction action) {
  return state.copyWith(error: action.error);
}

JournalEditorState _removeImageFailure(JournalEditorState state, RemoveImageFailureAction action) {
  return state.copyWith(error: action.error);
}

JournalEditorState _addImageToQuestionAnswerPairFailure(
    JournalEditorState state, AddImageToQuestionAnswerPairFailureAction action) {
  return state.copyWith(error: action.error);
}

JournalEditorState _removeImageFromQuestionAnswerPairFailure(
    JournalEditorState state, RemoveImageFromQuestionAnswerPairFailureAction action) {
  return state.copyWith(error: action.error);
}

JournalEditorState _addOrUpdateImageSuccess(JournalEditorState state, AddOrUpdateImageSuccessAction action) {
  return state.copyWith(currentJournalEntry: state.currentJournalEntry);
}

JournalEditorState _removeImageSuccess(JournalEditorState state, RemoveImageSuccessAction action) {
  return state.copyWith(currentJournalEntry: state.currentJournalEntry);
}

JournalEditorState _addImageToQuestionAnswerPairSuccess(
    JournalEditorState state, AddImageToQuestionAnswerPairSuccessAction action) {
  return state.copyWith(currentJournalEntry: state.currentJournalEntry);
}

JournalEditorState _removeImageFromQuestionAnswerPairSuccess(
    JournalEditorState state, RemoveImageFromQuestionAnswerPairSuccessAction action) {
  return state.copyWith(currentJournalEntry: state.currentJournalEntry);
}

JournalEditorState _updateJournalEntryWithImages(JournalEditorState state, UpdateJournalEntryWithImages action) {
  return state.copyWith(currentJournalEntry: action.journalEntry);
}

final journalEditorReducer = combineReducers<JournalEditorState>([
  TypedReducer<JournalEditorState, SaveJournalEntry>(_updateJournalEntry),
  TypedReducer<JournalEditorState, UpdateQuestionAnswer>(_updateQuestionAnswer),
  TypedReducer<JournalEditorState, ClearJournalEditorSuccess>(_clearMoodEditorFormSuccess),
  TypedReducer<JournalEditorState, InitializeJournalEditorSuccessAction>(_initializeJournalEditorSuccess),
  TypedReducer<JournalEditorState, InitializeJournalEditorFailureAction>(_initializeJournalEditorFailure),
  TypedReducer<JournalEditorState, ChangeJournalPageAction>(_changeJournalPage),
  TypedReducer<JournalEditorState, AddOrUpdateImageSuccessAction>(_addOrUpdateImageSuccess),
  TypedReducer<JournalEditorState, AddOrUpdateImageFailureAction>(_addOrUpdateImageFailure),
  TypedReducer<JournalEditorState, RemoveImageSuccessAction>(_removeImageSuccess),
  TypedReducer<JournalEditorState, RemoveImageFailureAction>(_removeImageFailure),
  TypedReducer<JournalEditorState, AddImageToQuestionAnswerPairSuccessAction>(_addImageToQuestionAnswerPairSuccess),
  TypedReducer<JournalEditorState, AddImageToQuestionAnswerPairFailureAction>(_addImageToQuestionAnswerPairFailure),
  TypedReducer<JournalEditorState, RemoveImageFromQuestionAnswerPairSuccessAction>(
      _removeImageFromQuestionAnswerPairSuccess),
  TypedReducer<JournalEditorState, RemoveImageFromQuestionAnswerPairFailureAction>(
      _removeImageFromQuestionAnswerPairFailure),
  TypedReducer<JournalEditorState, UpdateJournalEntryWithImages>(_updateJournalEntryWithImages),
]);
