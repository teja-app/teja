import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';
// lib/domain/redux/mood/mood_editor_state.dart

@immutable
class MoodEditorState {
  final MoodLog? currentMoodLog;
  final int currentPageIndex;
  final int? todayMoodIndex;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submissionSuccess;

  const MoodEditorState({
    this.currentMoodLog,
    this.currentPageIndex = 0,
    this.todayMoodIndex,
    this.isSubmitting = false,
    this.errorMessage,
    this.submissionSuccess = false,
  });

  MoodEditorState copyWith({
    MoodLog? currentMoodLog,
    int? currentPageIndex,
    int? todayMoodIndex,
    bool? isSubmitting,
    String? errorMessage,
    bool? submissionSuccess,
  }) {
    return MoodEditorState(
      currentMoodLog: currentMoodLog ?? this.currentMoodLog,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      todayMoodIndex: todayMoodIndex ?? this.todayMoodIndex,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }

  factory MoodEditorState.initialState() => const MoodEditorState();
}
