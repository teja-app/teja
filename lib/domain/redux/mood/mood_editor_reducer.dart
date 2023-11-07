import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/mood_editor_actions.dart';
import 'package:uuid/uuid.dart';

AppState _selectMood(AppState state, SelectMoodAction action) {
  // Create a new MoodLog or use existing one with the updated mood rating
  final MoodLog updatedMoodLog = state.moodEditorState.currentMoodLog?.copyWith(
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
  return state.copyWith(
    moodEditorState:
        state.moodEditorState.copyWith(currentMoodLog: updatedMoodLog),
  );
}

AppState _setTodayMoodLog(AppState state, SetTodayMoodLogAction action) {
  return state.copyWith(
    moodEditorState:
        state.moodEditorState.copyWith(todayMoodLog: action.moodLog),
  );
}

AppState _changePage(AppState state, ChangePageAction action) {
  // Return new state with updated page index
  return state.copyWith(
    moodEditorState:
        state.moodEditorState.copyWith(currentPageIndex: action.pageIndex),
  );
}

final moodEditorReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, SelectMoodAction>(_selectMood),
  TypedReducer<AppState, ChangePageAction>(_changePage),
  TypedReducer<AppState, SetTodayMoodLogAction>(_setTodayMoodLog),
];
