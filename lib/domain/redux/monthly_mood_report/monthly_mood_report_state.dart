import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

@immutable
class MonthlyMoodReportState {
  final bool isLoading;
  final Map<DateTime, double> currentMonthAverageMoodRatings;
  final String? errorMessage;
  final List<ScatterSpot> scatterSpots;
  final List<ScatterSpot> scatterStepSpots;

  const MonthlyMoodReportState({
    this.isLoading = false,
    this.currentMonthAverageMoodRatings = const {},
    this.errorMessage,
    this.scatterSpots = const [],
    this.scatterStepSpots = const [],
  });

  factory MonthlyMoodReportState.initial() {
    return const MonthlyMoodReportState(
      isLoading: false,
      currentMonthAverageMoodRatings: {},
      errorMessage: null,
      scatterSpots: [],
      scatterStepSpots: [],
    );
  }

  MonthlyMoodReportState copyWith({
    bool? isLoading,
    Map<DateTime, double>? currentMonthAverageMoodRatings,
    String? errorMessage,
    List<ScatterSpot>? scatterSpots,
    List<ScatterSpot>? scatterStepSpots,
  }) {
    return MonthlyMoodReportState(
      isLoading: isLoading ?? this.isLoading,
      currentMonthAverageMoodRatings:
          currentMonthAverageMoodRatings ?? this.currentMonthAverageMoodRatings,
      errorMessage: errorMessage ?? this.errorMessage,
      scatterSpots: scatterSpots ?? this.scatterSpots,
      scatterStepSpots: scatterStepSpots ?? this.scatterStepSpots,
    );
  }
}
