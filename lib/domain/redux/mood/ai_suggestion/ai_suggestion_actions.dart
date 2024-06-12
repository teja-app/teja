import 'package:flutter/material.dart';
import 'package:teja/domain/entities/mood_log.dart';

@immutable
class FetchAISuggestionAction {
  final MoodLogEntity moodLogEntity;

  const FetchAISuggestionAction(this.moodLogEntity);
}

@immutable
class FetchAISuggestionSuccessAction {
  final String moodId;
  final String suggestion;

  const FetchAISuggestionSuccessAction(this.moodId, this.suggestion);
}

@immutable
class FetchAISuggestionFailureAction {
  final String errorMessage;

  const FetchAISuggestionFailureAction(this.errorMessage);
}

@immutable
class UpdateAISuggestionAction {
  final String moodId;
  final String suggestion;

  const UpdateAISuggestionAction(this.moodId, this.suggestion);
}
