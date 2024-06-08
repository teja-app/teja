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
  final List<Map<String, bool>> checklist;

  const YearlySleepReportFetchedSuccessAction(
      this.yearlySleepData, this.checklist);
}

@immutable
class YearlySleepReportFetchFailedAction {
  final String errorMessage;

  const YearlySleepReportFetchFailedAction(this.errorMessage);
}
