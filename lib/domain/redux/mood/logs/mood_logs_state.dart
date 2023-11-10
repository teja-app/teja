import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class MoodLogsState {
  final Map<String, MoodLog>
      moodLogsByDate; // String keys as date representations
  final bool isFetching;
  final String? errorMessage;
  final bool fetchSuccess;

  const MoodLogsState({
    this.moodLogsByDate = const {},
    this.isFetching = false,
    this.errorMessage,
    this.fetchSuccess = false,
  });

  MoodLogsState copyWith({
    Map<String, MoodLog>? moodLogsByDate,
    bool? isFetching,
    String? errorMessage,
    bool? fetchSuccess,
  }) {
    return MoodLogsState(
      moodLogsByDate: moodLogsByDate ?? this.moodLogsByDate,
      isFetching: isFetching ?? this.isFetching,
      errorMessage: errorMessage ?? this.errorMessage,
      fetchSuccess: fetchSuccess ?? this.fetchSuccess,
    );
  }

  factory MoodLogsState.initialState() => const MoodLogsState();
}
