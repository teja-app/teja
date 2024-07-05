import 'package:flutter/material.dart';
import 'package:teja/domain/entities/mood_log.dart';

@immutable
class AISuggestionState {
  final bool isLoading;
  final String? errorMessage;
  final List<MoodLogEntity> moodLogs;

  const AISuggestionState({
    this.isLoading = false,
    this.errorMessage,
    this.moodLogs = const [],
  });

  AISuggestionState copyWith({
    bool? isLoading,
    bool updateErrorMessage = false,
    String? errorMessage,
    List<MoodLogEntity>? moodLogs,
  }) {
    return AISuggestionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: updateErrorMessage ? errorMessage : this.errorMessage,
      moodLogs: moodLogs ?? this.moodLogs,
    );
  }

  factory AISuggestionState.initial() => const AISuggestionState();
}
