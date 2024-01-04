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

JournalEditorState _clearJournalEditor(JournalEditorState state, ClearJournalEditor action) {
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

final journalEditorReducer = combineReducers<JournalEditorState>([
  TypedReducer<JournalEditorState, SaveJournalEntry>(_updateJournalEntry),
  TypedReducer<JournalEditorState, UpdateQuestionAnswer>(_updateQuestionAnswer),
  TypedReducer<JournalEditorState, ClearJournalEditor>(_clearJournalEditor),
  TypedReducer<JournalEditorState, InitializeJournalEditorSuccessAction>(_initializeJournalEditorSuccess),
  TypedReducer<JournalEditorState, InitializeJournalEditorFailureAction>(_initializeJournalEditorFailure),
]);
