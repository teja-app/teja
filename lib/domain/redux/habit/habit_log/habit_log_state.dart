import 'package:flutter/material.dart';
import 'package:teja/domain/entities/habit_log_entity.dart';

@immutable
class HabitLogState {
  final List<HabitLogEntity> habitLogs;
  final bool isLoading;
  final Exception? error;

  const HabitLogState({
    required this.habitLogs,
    this.isLoading = false,
    this.error,
  });

  HabitLogState copyWith({
    List<HabitLogEntity>? habitLogs,
    bool? isLoading,
    Exception? error,
  }) {
    return HabitLogState(
      habitLogs: habitLogs ?? this.habitLogs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory HabitLogState.initial() => const HabitLogState(habitLogs: []);
}
