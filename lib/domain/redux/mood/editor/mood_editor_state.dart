import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodEditorState {
  final MoodLog? currentMoodLog;
  final int currentPageIndex;
  final MoodLog? todayMoodLog;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submissionSuccess;

  const MoodEditorState({
    this.currentMoodLog,
    this.currentPageIndex = 0,
    this.todayMoodLog,
    this.isSubmitting = false,
    this.errorMessage,
    this.submissionSuccess = false,
  });

  MoodEditorState copyWith({
    MoodLog? currentMoodLog,
    int? currentPageIndex,
    MoodLog? todayMoodLog,
    bool? isSubmitting,
    String? errorMessage,
    bool? submissionSuccess,
    bool clearTodayMoodLog = false,
  }) {
    return MoodEditorState(
      currentMoodLog: currentMoodLog ?? this.currentMoodLog,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      todayMoodLog:
          clearTodayMoodLog ? null : todayMoodLog ?? this.todayMoodLog,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }

  factory MoodEditorState.initialState() => const MoodEditorState();
}
