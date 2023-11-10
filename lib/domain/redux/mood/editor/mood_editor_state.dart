import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodEditorState {
  final MoodLog? currentMoodLog;
  final List<MasterFeeling>? masterFeelings;
  final int currentPageIndex;
  final bool isFetchingFeelings; // Indicates if the feelings are being fetched
  final bool isSubmitting;
  final String? errorMessage;
  final bool submissionSuccess;

  const MoodEditorState({
    this.currentMoodLog,
    this.masterFeelings,
    this.currentPageIndex = 0,
    this.isFetchingFeelings = false, // Initialize the new variable
    this.isSubmitting = false,
    this.errorMessage,
    this.submissionSuccess = false,
  });

  // Extend copyWith to include the new variable
  MoodEditorState copyWith({
    MoodLog? currentMoodLog,
    List<MasterFeeling>? masterFeelings,
    int? currentPageIndex,
    bool? isFetchingFeelings, // Add the new parameter
    bool? isSubmitting,
    String? errorMessage,
    bool? submissionSuccess,
  }) {
    return MoodEditorState(
      currentMoodLog: currentMoodLog ?? this.currentMoodLog,
      masterFeelings: masterFeelings ?? this.masterFeelings,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isFetchingFeelings: isFetchingFeelings ??
          this.isFetchingFeelings, // Use the new parameter
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }

  factory MoodEditorState.initialState() => const MoodEditorState();
}
