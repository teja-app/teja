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

@immutable
class FetchAITitleAction {
  final MoodLogEntity moodLogEntity;

  const FetchAITitleAction(this.moodLogEntity);
}

@immutable
class FetchAITitleSuccessAction {
  final String moodId;
  final String title;

  const FetchAITitleSuccessAction(this.moodId, this.title);
}

@immutable
class FetchAITitleFailureAction {
  final String errorMessage;

  const FetchAITitleFailureAction(this.errorMessage);
}

@immutable
class UpdateAITitleAction {
  final String moodId;
  final String title;

  const UpdateAITitleAction(this.moodId, this.title);
}

@immutable
class FetchAIAffirmationAction {
  final MoodLogEntity moodLogEntity;

  const FetchAIAffirmationAction(this.moodLogEntity);
}

@immutable
class FetchAIAffirmationSuccessAction {
  final String moodId;
  final String affirmation;

  const FetchAIAffirmationSuccessAction(this.moodId, this.affirmation);
}

@immutable
class FetchAIAffirmationFailureAction {
  final String errorMessage;

  const FetchAIAffirmationFailureAction(this.errorMessage);
}

@immutable
class UpdateAIAffirmationAction {
  final String moodId;
  final String affirmation;

  const UpdateAIAffirmationAction(this.moodId, this.affirmation);
}
