import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/core_actions.dart';

@immutable
class SelectMoodAction {
  final int moodRating;
  const SelectMoodAction(this.moodRating);
}

@immutable
class ChangePageAction {
  final int pageIndex;
  const ChangePageAction(this.pageIndex);
}

@immutable
class MoodUpdatedAction extends SuccessAction {
  MoodUpdatedAction(String message) : super(message);
}

@immutable
class MoodUpdateFailedAction extends FailureAction {
  MoodUpdateFailedAction(String error) : super(error);
}

@immutable
class FetchFeelingsAction {}

@immutable
class FetchFeelingsInProgressAction {}

@immutable
class FeelingsFetchedAction {
  final List<MasterFeeling> feelings;
  const FeelingsFetchedAction(this.feelings);
}

@immutable
class FeelingsFetchFailedAction {
  final String error;
  const FeelingsFetchFailedAction(this.error);
}
