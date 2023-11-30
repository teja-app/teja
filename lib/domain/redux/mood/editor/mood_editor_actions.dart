import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/core_actions.dart';

@immutable
class TriggerSelectMoodAction {
  final int moodRating;
  final String? moodLogId;

  const TriggerSelectMoodAction(this.moodRating, [this.moodLogId]);
}

@immutable
class SelectMoodSuccessAction {
  final MoodLogEntity moodLog;

  const SelectMoodSuccessAction(this.moodLog);
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
class TriggerUpdateFeelingsAction {
  final String moodLogId;
  final List<String> feelingSlugs;
  final List<MasterFeelingEntity> selectedFeelings;

  const TriggerUpdateFeelingsAction(
    this.moodLogId,
    this.feelingSlugs,
    this.selectedFeelings,
  );
}

@immutable
class UpdateFeelingsSuccessAction {
  final String moodLogId;
  final List<FeelingEntity> feelings;
  final Map<int, List<int>>? feelingFactorLink;
  final List<MasterFeelingEntity> selectedFeelings;

  const UpdateFeelingsSuccessAction(
    this.moodLogId,
    this.feelings,
    this.feelingFactorLink,
    this.selectedFeelings,
  );
}

@immutable
class UpdateFactorsAction {
  final int feelingId;
  final List<int?> factorIds;

  const UpdateFactorsAction({required this.feelingId, required this.factorIds});
}

@immutable
class UpdateFactorsSuccessAction {
  final String message;
  const UpdateFactorsSuccessAction(this.message);
}

@immutable
class UpdateFactorsFailureAction {
  final String error;
  const UpdateFactorsFailureAction(this.error);
}

@immutable
class ClearMoodEditorFormAction {
  const ClearMoodEditorFormAction();
}
