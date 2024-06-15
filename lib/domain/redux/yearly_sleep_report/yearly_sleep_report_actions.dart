import 'package:flutter/material.dart';

@immutable
abstract class YearlySleepReportAction {}

@immutable
class FetchYearlySleepReportAction {
  final DateTime referenceDate;

  const FetchYearlySleepReportAction(this.referenceDate);
}

@immutable
class YearlySleepReportFetchInProgressAction {}

@immutable
class YearlySleepReportFetchedSuccessAction {
  final Map<DateTime, int> yearlySleepData;

  const YearlySleepReportFetchedSuccessAction(this.yearlySleepData);
}

@immutable
class YearlySleepReportFetchFailedAction {
  final String errorMessage;

  const YearlySleepReportFetchFailedAction(this.errorMessage);
}
