import 'package:flutter/material.dart';

@immutable
class MonthlyMoodReportState {
  final bool isLoading;
  final Map<DateTime, double> currentMonthAverageMoodRatings;
  final String? errorMessage;

  const MonthlyMoodReportState({
    this.isLoading = false,
    this.currentMonthAverageMoodRatings = const {},
    this.errorMessage,
  });

  factory MonthlyMoodReportState.initial() {
    return const MonthlyMoodReportState(
      isLoading: false,
      currentMonthAverageMoodRatings: {},
      errorMessage: null,
    );
  }

  MonthlyMoodReportState copyWith({
    bool? isLoading,
    Map<DateTime, double>? currentMonthAverageMoodRatings,
    String? errorMessage,
  }) {
    return MonthlyMoodReportState(
      isLoading: isLoading ?? this.isLoading,
      currentMonthAverageMoodRatings:
          currentMonthAverageMoodRatings ?? this.currentMonthAverageMoodRatings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
