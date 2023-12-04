import 'package:flutter/material.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/core_actions.dart';

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
  final List<MasterFeelingEntity> selectedFeelings;

  const UpdateFeelingsSuccessAction(
    this.moodLogId,
    this.feelings,
    this.selectedFeelings,
  );
}

@immutable
class UpdateLinkedFactorsSuccessAction {
  final Map<int, List<int>>? feelingFactorLink;

  const UpdateLinkedFactorsSuccessAction(this.feelingFactorLink);
}

@immutable
class UpdateFactorsAction {
  final String? moodLogId;
  final int feelingId;
  final List<MasterFactorEntity?> factors;

  const UpdateFactorsAction({
    required this.moodLogId,
    required this.feelingId,
    required this.factors,
  });
}

@immutable
class UpdateFactorsSuccessAction {
  final String? moodLogId;
  final int feelingId;
  final List<MasterFactorEntity?>? factors;

  const UpdateFactorsSuccessAction({
    required this.moodLogId,
    required this.feelingId,
    required this.factors,
  });
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

@immutable
class FetchLinkedFactorsAction {
  final List<String> feelingSlugs;

  const FetchLinkedFactorsAction(this.feelingSlugs);
}
