import 'package:flutter/material.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_state.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';

@immutable
class AppState {
  final AuthState authState; // Nested AuthState
  final MoodEditorState moodEditorState;
  final MoodDetailState moodDetailPage;

  const AppState({
    required this.authState,
    required this.moodEditorState,
    required this.moodDetailPage,
  });

  AppState copyWith({
    AuthState? authState,
    MoodEditorState? moodEditorState,
    MoodDetailState? moodDetailPage,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      moodEditorState: moodEditorState ?? this.moodEditorState,
      moodDetailPage: moodDetailPage ?? this.moodDetailPage,
    );
  }

  static AppState initialState() {
    return AppState(
      authState: AuthState.initialState(),
      moodEditorState: MoodEditorState.initialState(),
      moodDetailPage: MoodDetailState.initialState(),
    );
  }
}
