import 'package:flutter/material.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/list/state.dart';

abstract class MoodListAction {}

@immutable
class LoadMoodLogsListAction extends MoodListAction {
  final int pageKey;
  final int pageSize;

  LoadMoodLogsListAction(this.pageKey, this.pageSize);
}

@immutable
class ApplyMoodLogsFilterAction extends MoodListAction {
  final MoodLogFilter filter;

  ApplyMoodLogsFilterAction(this.filter);
}

@immutable
class ResetMoodLogsListAction extends MoodListAction {}

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
