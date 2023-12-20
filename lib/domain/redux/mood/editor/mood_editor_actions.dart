import 'package:flutter/material.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/core_actions.dart';

@immutable
class InitializeMoodEditorAction {
  final String moodLogId;

  const InitializeMoodEditorAction(this.moodLogId);
}

@immutable
class TriggerSelectMoodAction {
  final int moodRating;
  final String? moodLogId;
  final DateTime? timestamp;

  const TriggerSelectMoodAction({
    required this.moodRating,
    this.timestamp,
    this.moodLogId,
  });
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
class UpdateBroadFactorsAction {
  final String moodLogId;
  final List<String> factors;

  const UpdateBroadFactorsAction({
    required this.moodLogId,
    required this.factors,
  });
}

@immutable
class UpdateBroadFactorsSuccessAction {
  final String moodLogId;
  final List<String> factors;

  const UpdateBroadFactorsSuccessAction({
    required this.moodLogId,
    required this.factors,
  });
}

@immutable
class UpdateBroadFactorsFailureAction {
  final String error;

  const UpdateBroadFactorsFailureAction(this.error);
}

@immutable
class UpdateMoodLogCommentAction {
  final String moodLogId;
  final String comment;

  const UpdateMoodLogCommentAction(this.moodLogId, this.comment);
}

@immutable
class UpdateMoodLogCommentSuccessAction {
  final String moodLogId;
  final String comment;

  const UpdateMoodLogCommentSuccessAction(this.moodLogId, this.comment);
}

@immutable
class UpdateMoodLogCommentFailureAction {
  final String error;

  const UpdateMoodLogCommentFailureAction(this.error);
}

@immutable
class UpdateFactorsAction {
  final String? moodLogId;
  final int feelingId;
  final List<SubCategoryEntity?> factors;

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
  final List<SubCategoryEntity?>? factors;

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
class ClearMoodEditorSuccessFormAction {
  const ClearMoodEditorSuccessFormAction();
}
