import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MonthlyMoodReportAction {}

@immutable
class FetchMonthlyMoodReportAction {
  final DateTime referenceDate;

  const FetchMonthlyMoodReportAction(this.referenceDate);
}

@immutable
class FetchingScatterSpotsAction {}

@immutable
class MonthlyMoodReportFetchInProgressAction {}

@immutable
class MonthlyMoodReportFetchedSuccessAction {
  final Map<DateTime, double> currentMonthAverageMoodRatings;
  final List<ScatterSpot> scatterSpots;

  const MonthlyMoodReportFetchedSuccessAction(
    this.currentMonthAverageMoodRatings,
    this.scatterSpots,
  );
}

@immutable
class MonthlyMoodReportFetchFailedAction {
  final String errorMessage;

  const MonthlyMoodReportFetchFailedAction(this.errorMessage);
}
