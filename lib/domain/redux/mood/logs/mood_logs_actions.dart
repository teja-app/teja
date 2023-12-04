import 'package:flutter/material.dart';
import 'package:teja/domain/entities/mood_log.dart';

@immutable
class FetchMoodLogsAction {
  FetchMoodLogsAction();
}

@immutable
class FetchMoodLogsSuccessAction {
  final Map<DateTime, MoodLogEntity> moodLogs;

  FetchMoodLogsSuccessAction(this.moodLogs);
}

@immutable
class FetchMoodLogsErrorAction {
  final String errorMessage;

  FetchMoodLogsErrorAction(this.errorMessage);
}

@immutable
class UpdateMoodLogAction {
  final DateTime date;
  final MoodLogEntity moodLog;

  UpdateMoodLogAction(this.date, this.moodLog);
}
