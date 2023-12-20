import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_state.dart';

MoodEditorState _selectMood(MoodEditorState state, SelectMoodSuccessAction action) {
  return state.copyWith(currentMoodLog: action.moodLog);
}

MoodEditorState _changePage(MoodEditorState state, ChangePageAction action) {
  // Return new state with updated page index
  return state.copyWith(currentPageIndex: action.pageIndex);
}

MoodEditorState _updateFeelingsSuccess(MoodEditorState state, UpdateFeelingsSuccessAction action) {
  if (state.currentMoodLog?.id == action.moodLogId) {
    MoodLogEntity updatedMoodLog = state.currentMoodLog!.copyWith(feelings: action.feelings);
    return state.copyWith(
      currentMoodLog: updatedMoodLog,
      selectedFeelings: action.selectedFeelings, // Update the state with the new selectedFeelings
    );
  }
  return state;
}

MoodEditorState _clearMoodEditorFormSuccess(MoodEditorState state, ClearMoodEditorSuccessFormAction action) {
  return MoodEditorState.initialState().copyWith(
    selectedFeelings: [],
  );
}

MoodEditorState _updateFactorsSuccess(MoodEditorState state, UpdateFactorsSuccessAction action) {
  if (state.currentMoodLog?.id == action.moodLogId) {
    // Ensure that selectedFactorsForFeelings is not null
    var updatedFactorsForFeelings = Map<int, List<SubCategoryEntity?>>.from(state.selectedFactorsForFeelings ?? {});

    // Update the factors for the specific feeling
    updatedFactorsForFeelings[action.feelingId] = action.factors ?? [];

    return state.copyWith(
      selectedFactorsForFeelings: updatedFactorsForFeelings,
    );
  }
  return state;
}

MoodEditorState _updateBroadFactorsSuccess(MoodEditorState state, UpdateBroadFactorsSuccessAction action) {
  if (state.currentMoodLog?.id == action.moodLogId) {
    MoodLogEntity updatedMoodLog = state.currentMoodLog!.copyWith(factors: action.factors);
    return state.copyWith(currentMoodLog: updatedMoodLog);
  }
  return state;
}

MoodEditorState _updateMoodLogCommentSuccess(MoodEditorState state, UpdateMoodLogCommentSuccessAction action) {
  if (state.currentMoodLog?.id == action.moodLogId) {
    MoodLogEntity updatedMoodLog = state.currentMoodLog!.copyWith(comment: action.comment);
    return state.copyWith(currentMoodLog: updatedMoodLog);
  }
  return state;
}

// Include the new reducer methods in the combined reducer
final moodEditorReducer = combineReducers<MoodEditorState>([
  TypedReducer<MoodEditorState, SelectMoodSuccessAction>(_selectMood),
  TypedReducer<MoodEditorState, ChangePageAction>(_changePage),
  TypedReducer<MoodEditorState, UpdateFeelingsSuccessAction>(_updateFeelingsSuccess),
  TypedReducer<MoodEditorState, ClearMoodEditorSuccessFormAction>(_clearMoodEditorFormSuccess),
  TypedReducer<MoodEditorState, UpdateFactorsSuccessAction>(_updateFactorsSuccess),
  TypedReducer<MoodEditorState, UpdateMoodLogCommentSuccessAction>(_updateMoodLogCommentSuccess),
  TypedReducer<MoodEditorState, UpdateBroadFactorsSuccessAction>(_updateBroadFactorsSuccess),
]);
