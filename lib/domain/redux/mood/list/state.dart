import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodLogFilter {
  final List<int> selectedMoodRatings;

  const MoodLogFilter({this.selectedMoodRatings = const []});

  MoodLogFilter copyWith({
    List<int>? selectedMoodRatings,
  }) {
    return MoodLogFilter(
      selectedMoodRatings: selectedMoodRatings ?? this.selectedMoodRatings,
    );
  }
}

@immutable
class MoodLogListState {
  final bool isLoading;
  final List<MoodLogEntity> moodLogs;
  final String? errorMessage;
  final bool isLastPage;
  final MoodLogFilter filter; // Updated to use MoodLogFilter

  const MoodLogListState({
    this.isLoading = false,
    this.moodLogs = const [],
    this.errorMessage,
    this.isLastPage = false,
    this.filter = const MoodLogFilter(), // Default empty filter
  });

  factory MoodLogListState.initial() {
    return const MoodLogListState(
      isLoading: false,
      moodLogs: [],
      errorMessage: null,
      isLastPage: false,
    );
  }

  MoodLogListState copyWith({
    bool? isLoading,
    List<MoodLogEntity>? moodLogs,
    String? errorMessage,
    bool? isLastPage,
    MoodLogFilter? filter,
  }) {
    return MoodLogListState(
      isLoading: isLoading ?? this.isLoading,
      moodLogs: moodLogs ?? this.moodLogs,
      errorMessage: errorMessage ?? this.errorMessage,
      isLastPage: isLastPage ?? this.isLastPage,
      filter: filter ?? this.filter,
    );
  }
}
