import 'package:flutter/material.dart';
import 'package:swayam/domain/redux/mood/mood_editor_state.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';

@immutable
class AppState {
  final AuthState authState; // Nested AuthState
  final MoodEditorState moodEditorState;

  const AppState({
    required this.authState,
    required this.moodEditorState,
  });

  AppState copyWith({
    AuthState? authState,
    MoodEditorState? moodEditorState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      moodEditorState: moodEditorState ?? this.moodEditorState,
    );
  }

  static AppState initialState() {
    return AppState(
      authState: AuthState.initialState(),
      moodEditorState: MoodEditorState.initialState(),
    );
  }
}
