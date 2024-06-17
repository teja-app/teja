import 'package:flutter/material.dart';

@immutable
abstract class ProfilePageAction {}

@immutable
class UpdateChartSequenceAction extends ProfilePageAction {
  final List<String> chartSequence;

  UpdateChartSequenceAction(this.chartSequence);
}

@immutable
class FetchChartSequenceAction extends ProfilePageAction {}

@immutable
class ChartSequenceFetchInProgressAction extends ProfilePageAction {}

@immutable
class ChartSequenceFetchSuccessAction extends ProfilePageAction {
  final List<String> chartSequence;

  ChartSequenceFetchSuccessAction(this.chartSequence);
}

@immutable
class ChartSequenceFetchFailedAction extends ProfilePageAction {
  final String errorMessage;

  ChartSequenceFetchFailedAction(this.errorMessage);
}
