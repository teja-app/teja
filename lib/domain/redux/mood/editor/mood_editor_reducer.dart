import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_state.dart';

MoodEditorState _selectMood(
    MoodEditorState state, SelectMoodSuccessAction action) {
  return state.copyWith(currentMoodLog: action.moodLog);
}

MoodEditorState _changePage(MoodEditorState state, ChangePageAction action) {
  // Return new state with updated page index
  return state.copyWith(currentPageIndex: action.pageIndex);
}

MoodEditorState _updateFeelingsSuccess(
    MoodEditorState state, UpdateFeelingsSuccessAction action) {
  if (state.currentMoodLog?.id == action.moodLogId) {
    MoodLogEntity updatedMoodLog =
        state.currentMoodLog!.copyWith(feelings: action.feelings);
    return state.copyWith(
      currentMoodLog: updatedMoodLog,
      feelingFactorLink: action.feelingFactorLink,
    );
  }
  return state;
}

// Include the new reducer methods in the combined reducer
final moodEditorReducer = combineReducers<MoodEditorState>([
  TypedReducer<MoodEditorState, SelectMoodSuccessAction>(_selectMood),
  TypedReducer<MoodEditorState, ChangePageAction>(_changePage),
  TypedReducer<MoodEditorState, UpdateFeelingsSuccessAction>(
      _updateFeelingsSuccess),
]);
