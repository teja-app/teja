import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_state.dart';
import 'package:uuid/uuid.dart';

MoodEditorState _selectMood(MoodEditorState state, SelectMoodAction action) {
  // Create a new MoodLog or use existing one with the updated mood rating
  final MoodLog updatedMoodLog = state.currentMoodLog?.copyWith(
        moodRating: action.moodRating,
      ) ??
      MoodLog(
        id: const Uuid().v7(),
        timestamp: DateTime.now(),
        moodRating: action.moodRating,
        comment: '',
        feelings: [],
      );

  // Return new state with updated mood log
  return state.copyWith(currentMoodLog: updatedMoodLog);
}

MoodEditorState _changePage(MoodEditorState state, ChangePageAction action) {
  // Return new state with updated page index
  return state.copyWith(currentPageIndex: action.pageIndex);
}

MoodEditorState _fetchFeelingsInProgress(
    MoodEditorState state, FetchFeelingsInProgressAction action) {
  return state.copyWith(
    isFetchingFeelings: true,
    errorMessage: null,
  );
}

MoodEditorState _feelingsFetched(
    MoodEditorState state, FeelingsFetchedAction action) {
  return state.copyWith(
    masterFeelings: action.feelings,
    isFetchingFeelings: false,
  );
}

MoodEditorState _feelingsFetchFailed(
    MoodEditorState state, FeelingsFetchFailedAction action) {
  return state.copyWith(
    errorMessage: action.error,
    isFetchingFeelings: false,
  );
}

// Include the new reducer methods in the combined reducer
final moodEditorReducer = combineReducers<MoodEditorState>([
  TypedReducer<MoodEditorState, SelectMoodAction>(_selectMood),
  TypedReducer<MoodEditorState, ChangePageAction>(_changePage),
  TypedReducer<MoodEditorState, FetchFeelingsInProgressAction>(
      _fetchFeelingsInProgress),
  TypedReducer<MoodEditorState, FeelingsFetchedAction>(_feelingsFetched),
  TypedReducer<MoodEditorState, FeelingsFetchFailedAction>(
      _feelingsFetchFailed),
]);
