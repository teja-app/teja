import 'package:flutter/material.dart';
import 'package:swayam/domain/redux/home/home_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_state.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_state.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';

@immutable
class AppState {
  final AuthState authState; // Nested AuthState
  final MoodEditorState moodEditorState;
  final MoodDetailState moodDetailPage;
  final MoodLogsState moodLogsState;
  final HomeState homeState;

  const AppState({
    required this.authState,
    required this.homeState,
    required this.moodEditorState,
    required this.moodDetailPage,
    required this.moodLogsState,
  });

  AppState copyWith({
    AuthState? authState,
    HomeState? homeState,
    MoodEditorState? moodEditorState,
    MoodDetailState? moodDetailPage,
    MoodLogsState? moodLogsState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      homeState: homeState ?? this.homeState,
      moodEditorState: moodEditorState ?? this.moodEditorState,
      moodDetailPage: moodDetailPage ?? this.moodDetailPage,
      moodLogsState: moodLogsState ?? this.moodLogsState,
    );
  }

  static AppState initialState() {
    return AppState(
      authState: AuthState.initialState(),
      homeState: HomeState.initialState(),
      moodEditorState: MoodEditorState.initialState(),
      moodDetailPage: MoodDetailState.initialState(),
      moodLogsState: MoodLogsState.initialState(),
    );
  }
}
