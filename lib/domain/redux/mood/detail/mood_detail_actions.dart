import 'package:flutter/material.dart';
import 'package:teja/domain/entities/mood_log.dart';

@immutable
class LoadMoodDetailAction {
  final String moodId;
  const LoadMoodDetailAction(this.moodId);
}

@immutable
class LoadMoodDetailSuccessAction {
  final MoodLogEntity moodLog;
  const LoadMoodDetailSuccessAction(this.moodLog);
}

@immutable
class LoadMoodDetailFailureAction {
  final String errorMessage;
  const LoadMoodDetailFailureAction(this.errorMessage);
}

@immutable
class DeleteMoodDetailAction {
  final String moodId;
  const DeleteMoodDetailAction(this.moodId);
}

@immutable
class DeleteMoodDetailSuccessAction {
  const DeleteMoodDetailSuccessAction();
}

@immutable
class DeleteMoodDetailFailureAction {
  final String errorMessage;
  const DeleteMoodDetailFailureAction(this.errorMessage);
}
