import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/habit_entity.dart';

@immutable
class HabitState {
  final List<HabitEntity> habits;
  final bool isLoading;
  final Exception? error;

  const HabitState({
    required this.habits,
    this.isLoading = false,
    this.error,
  });

  HabitState copyWith({
    List<HabitEntity>? habits,
    bool? isLoading,
    Exception? error,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory HabitState.initial() => HabitState(habits: []);
}
