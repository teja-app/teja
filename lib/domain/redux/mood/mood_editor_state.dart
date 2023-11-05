import 'package:flutter/material.dart';
import 'package:swayam/infrastruture/api/mood_api.dart';

@immutable
class MoodEditorState {
  final MoodLog? currentMoodLog; // Nullable to represent no active edit.
  final int? currentPageIndex;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submissionSuccess;

  const MoodEditorState({
    this.currentMoodLog,
    this.isSubmitting = false,
    this.currentPageIndex = 0,
    this.errorMessage,
    this.submissionSuccess = false,
  });

  MoodEditorState copyWith(
    newMoodLog, {
    MoodLog? currentMoodLog,
    bool? isSubmitting,
    int? currentPageIndex,
    String? errorMessage,
    bool? submissionSuccess,
  }) {
    return MoodEditorState(
      currentMoodLog: currentMoodLog ?? this.currentMoodLog,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }

  factory MoodEditorState.initialState() {
    return const MoodEditorState(
      currentMoodLog: null, // No mood log is being edited initially.
      isSubmitting: false,
      currentPageIndex: 0,
      errorMessage: null,
      submissionSuccess: false,
    );
  }
}
