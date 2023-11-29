import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodEditorState {
  final MoodLogEntity? currentMoodLog;
  final int currentPageIndex;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submissionSuccess;
  final Map<int, List<int>>? feelingFactorLink;

  const MoodEditorState({
    this.currentMoodLog,
    this.currentPageIndex = 0,
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.errorMessage,
    this.feelingFactorLink,
  });

  // Extend copyWith to include the new variable
  MoodEditorState copyWith({
    MoodLogEntity? currentMoodLog,
    int? currentPageIndex,
    bool? isFetchingFeelings, // Add the new parameter
    bool? isSubmitting,
    String? errorMessage,
    bool? submissionSuccess,
    Map<int, List<int>>? feelingFactorLink,
  }) {
    return MoodEditorState(
      currentMoodLog: currentMoodLog ?? this.currentMoodLog,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      feelingFactorLink: feelingFactorLink ?? this.feelingFactorLink,
    );
  }

  factory MoodEditorState.initialState() => const MoodEditorState();
}
