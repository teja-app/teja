import 'package:flutter/material.dart';

@immutable
abstract class MonthlyMoodReportAction {}

@immutable
class FetchMonthlyMoodReportAction {
  final DateTime referenceDate;

  const FetchMonthlyMoodReportAction(this.referenceDate);
}

@immutable
class MonthlyMoodReportFetchInProgressAction {}

@immutable
class MonthlyMoodReportFetchedSuccessAction {
  final Map<DateTime, double> currentMonthAverageMoodRatings;

  const MonthlyMoodReportFetchedSuccessAction(
      this.currentMonthAverageMoodRatings);
}

@immutable
class MonthlyMoodReportFetchFailedAction {
  final String errorMessage;

  const MonthlyMoodReportFetchFailedAction(this.errorMessage);
}
