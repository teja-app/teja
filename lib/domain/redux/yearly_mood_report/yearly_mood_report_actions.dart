import 'package:flutter/material.dart';

@immutable
abstract class YearlyMoodReportAction {}

@immutable
class FetchYearlyMoodReportAction {
  final DateTime referenceDate;

  const FetchYearlyMoodReportAction(this.referenceDate);
}

@immutable
class YealryMoodReportFetchInProgressAction {}

@immutable
class YearlyMoodReportFetchedSuccessAction {
  final Map<DateTime, int> currentYearAverageMoodRatings;

  const YearlyMoodReportFetchedSuccessAction(
    this.currentYearAverageMoodRatings,
  );
}

@immutable
class YearlyMoodReportFetchFailedAction {
  final String errorMessage;

  const YearlyMoodReportFetchFailedAction(this.errorMessage);
}
