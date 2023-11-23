import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodLogListState {
  final bool isLoading;
  final List<MoodLogEntity> moodLogs;
  final String? errorMessage;
  final bool isLastPage;

  const MoodLogListState({
    this.isLoading = false,
    this.moodLogs = const [],
    this.errorMessage,
    this.isLastPage = false,
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
  }) {
    return MoodLogListState(
      isLoading: isLoading ?? this.isLoading,
      moodLogs: moodLogs ?? this.moodLogs,
      errorMessage: errorMessage ?? this.errorMessage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}
