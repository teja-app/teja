import 'package:flutter/material.dart';
import 'package:teja/domain/entities/mood_log.dart';

@immutable
class FetchMoodLogsAction {
  const FetchMoodLogsAction();
}

@immutable
class FetchMoodLogsSuccessAction {
  final Map<DateTime, List<MoodLogEntity>> moodLogs;

  const FetchMoodLogsSuccessAction(this.moodLogs);
}

@immutable
class FetchMoodLogsErrorAction {
  final String errorMessage;

  const FetchMoodLogsErrorAction(this.errorMessage);
}
