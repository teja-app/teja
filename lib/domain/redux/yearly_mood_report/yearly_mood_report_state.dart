import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

@immutable
class YearlyMoodReportState {
  final bool isLoading;
  final Map<DateTime, int> currentYearAverageMoodRatings;
  final String? errorMessage;

  const YearlyMoodReportState({
    this.isLoading = false,
    this.currentYearAverageMoodRatings = const {},
    this.errorMessage,
  });

  factory YearlyMoodReportState.initial() {
    return const YearlyMoodReportState(
      isLoading: false,
      currentYearAverageMoodRatings: {},
      errorMessage: null,
    );
  }

  YearlyMoodReportState copyWith({
    bool? isLoading,
    Map<DateTime, int>? currentYearAverageMoodRatings,
    String? errorMessage,
    List<ScatterSpot>? scatterSpots,
  }) {
    return YearlyMoodReportState(
      isLoading: isLoading ?? this.isLoading,
      currentYearAverageMoodRatings:
          currentYearAverageMoodRatings ?? this.currentYearAverageMoodRatings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
