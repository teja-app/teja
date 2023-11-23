import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/mood_log.dart';

abstract class MoodListAction {}

@immutable
class LoadMoodLogsListAction extends MoodListAction {
  final int pageKey;
  final int pageSize;

  LoadMoodLogsListAction(this.pageKey, this.pageSize);
}

@immutable
class FetchMoodLogsInProgressAction extends MoodListAction {}

@immutable
class MoodLogsListFetchedSuccessAction extends MoodListAction {
  final List<MoodLogEntity> moodLogs;
  final bool isLastPage;

  MoodLogsListFetchedSuccessAction(this.moodLogs, this.isLastPage);
}

@immutable
class MoodLogsListFetchFailedAction extends MoodListAction {
  final String errorMessage;

  MoodLogsListFetchFailedAction(this.errorMessage);
}
