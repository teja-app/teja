import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodDetailState {
  final MoodLogEntity? selectedMoodLog;
  final bool isLoading;
  final String? errorMessage;

  const MoodDetailState({
    this.selectedMoodLog,
    this.isLoading = false,
    this.errorMessage,
  });

  MoodDetailState copyWith({
    MoodLogEntity? selectedMoodLog,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MoodDetailState(
      selectedMoodLog: selectedMoodLog ?? this.selectedMoodLog,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory MoodDetailState.initialState() => const MoodDetailState();

  @override
  String toString() {
    return 'MoodDetailState(selectedMoodLog: $selectedMoodLog, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoodDetailState &&
        other.selectedMoodLog == selectedMoodLog &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      selectedMoodLog.hashCode ^ isLoading.hashCode ^ errorMessage.hashCode;
}
