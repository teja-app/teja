// Import the necessary packages and state
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/infrastruture/api/mood_api.dart';

@immutable
class SelectMoodAction {
  final int moodRating;

  const SelectMoodAction(this.moodRating);
}

AppState _selectMood(AppState state, SelectMoodAction action) {
  final MoodLog newMoodLog = state.moodEditorState.currentMoodLog?.copyWith(
        moodRating: action.moodRating,
      ) ??
      MoodLog(
        timestamp: DateTime.now(),
        moodRating: action.moodRating,
        comment: '',
        moodLogFeelings: [],
      );
  return state.copyWith(
    moodEditorState:
        state.moodEditorState.copyWith(newMoodLog, currentMoodLog: newMoodLog),
  );
}

@immutable
class ChangePageAction {
  final int pageIndex;
  const ChangePageAction(this.pageIndex);
}

AppState _changePage(AppState state, ChangePageAction action) {
  return state.copyWith(
    moodEditorState: state.moodEditorState.copyWith(
      state.moodEditorState.currentMoodLog,
      currentPageIndex: action.pageIndex,
    ),
  );
}

final moodEditorReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, SelectMoodAction>(_selectMood),
  TypedReducer<AppState, ChangePageAction>(_changePage),
];
