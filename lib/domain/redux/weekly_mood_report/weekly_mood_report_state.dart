import 'package:flutter/material.dart';

@immutable
class WeeklyMoodReportState {
  final bool isLoading;
  final Map<DateTime, double> currentWeekAverageMoodRatings;
  final Map<DateTime, double> previousWeekAverageMoodRatings;
  final String? errorMessage;

  const WeeklyMoodReportState({
    this.isLoading = false,
    this.currentWeekAverageMoodRatings = const {},
    this.previousWeekAverageMoodRatings = const {},
    this.errorMessage,
  });

  factory WeeklyMoodReportState.initial() {
    return const WeeklyMoodReportState(
      isLoading: false,
      currentWeekAverageMoodRatings: {},
      previousWeekAverageMoodRatings: {},
      errorMessage: null,
    );
  }

  WeeklyMoodReportState copyWith({
    bool? isLoading,
    Map<DateTime, double>? currentWeekAverageMoodRatings,
    Map<DateTime, double>? previousWeekAverageMoodRatings,
    String? errorMessage,
  }) {
    return WeeklyMoodReportState(
      isLoading: isLoading ?? this.isLoading,
      currentWeekAverageMoodRatings:
          currentWeekAverageMoodRatings ?? this.currentWeekAverageMoodRatings,
      previousWeekAverageMoodRatings:
          previousWeekAverageMoodRatings ?? this.previousWeekAverageMoodRatings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
