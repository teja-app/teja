import 'package:flutter/material.dart';

@immutable
abstract class WeeklyMoodReportAction {}

@immutable
class FetchWeeklyMoodReportAction {
  final DateTime referenceDate;

  const FetchWeeklyMoodReportAction(this.referenceDate);
}

@immutable
class WeeklyMoodReportFetchInProgressAction {}

@immutable
class WeeklyMoodReportFetchedSuccessAction {
  final Map<DateTime, double> currentWeekAverageMoodRatings;
  final Map<DateTime, double> previousWeekAverageMoodRatings;

  const WeeklyMoodReportFetchedSuccessAction(
      this.currentWeekAverageMoodRatings, this.previousWeekAverageMoodRatings);
}

@immutable
class WeeklyMoodReportFetchFailedAction {
  final String errorMessage;

  const WeeklyMoodReportFetchFailedAction(this.errorMessage);
}
