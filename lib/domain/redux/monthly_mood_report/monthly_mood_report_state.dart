import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:teja/domain/redux/constants/checklist_strings.dart';

@immutable
class MonthlyMoodReportState {
  final bool isLoading;
  final Map<DateTime, double> currentMonthAverageMoodRatings;
  final String? errorMessage;
  final List<ScatterSpot> scatterSpots;
  final List<Map<String, bool>> checklist;

  const MonthlyMoodReportState({
    this.isLoading = false,
    this.currentMonthAverageMoodRatings = const {},
    this.errorMessage,
    this.scatterSpots = const [],
    this.checklist = const [
      {SLEEP_DATA: false},
      {MOOD_DATA: false},
    ],
  });

  factory MonthlyMoodReportState.initial() {
    return const MonthlyMoodReportState(
      isLoading: false,
      currentMonthAverageMoodRatings: {},
      errorMessage: null,
      scatterSpots: [],
      checklist: [
        {SLEEP_DATA: false},
        {MOOD_DATA: false},
      ],
    );
  }

  MonthlyMoodReportState copyWith({
    bool? isLoading,
    Map<DateTime, double>? currentMonthAverageMoodRatings,
    String? errorMessage,
    List<ScatterSpot>? scatterSpots,
    List<Map<String, bool>>? checklist,
  }) {
    return MonthlyMoodReportState(
      isLoading: isLoading ?? this.isLoading,
      currentMonthAverageMoodRatings:
          currentMonthAverageMoodRatings ?? this.currentMonthAverageMoodRatings,
      errorMessage: errorMessage ?? this.errorMessage,
      scatterSpots: scatterSpots ?? this.scatterSpots,
      checklist: checklist ?? this.checklist,
    );
  }
}
