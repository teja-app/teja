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

// Include the new reducer methods in the combined reducer
final moodEditorReducer = combineReducers<MoodEditorState>([
  TypedReducer<MoodEditorState, SelectMoodAction>(_selectMood),
  TypedReducer<MoodEditorState, ChangePageAction>(_changePage),
]);
