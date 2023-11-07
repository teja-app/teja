import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

@immutable
class LoadMoodDetailAction {
  final String moodId;
  const LoadMoodDetailAction(this.moodId);
}

@immutable
class LoadMoodDetailSuccessAction {
  final MoodLog moodLog;
  const LoadMoodDetailSuccessAction(this.moodLog);
}

@immutable
class LoadMoodDetailFailureAction {
  final String errorMessage;
  const LoadMoodDetailFailureAction(this.errorMessage);
}
