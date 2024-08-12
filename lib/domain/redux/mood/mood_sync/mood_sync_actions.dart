import 'package:teja/domain/entities/mood_log.dart';

class SyncMoodLogs {
  const SyncMoodLogs();
}

class SyncMoodLogsSuccessAction {
  final List<MoodLogEntity> serverChanges;
  final List<MoodLogEntity> clientChanges;
  final DateTime newSyncTimestamp;

  const SyncMoodLogsSuccessAction({
    required this.serverChanges,
    required this.clientChanges,
    required this.newSyncTimestamp,
  });
}

class SyncMoodLogsFailureAction {
  final String error;

  const SyncMoodLogsFailureAction(this.error);
}

class FetchInitialMoodLogsAction {
  const FetchInitialMoodLogsAction();
}

class FetchInitialMoodLogsSuccessAction {
  final List<MoodLogEntity> entries;

  const FetchInitialMoodLogsSuccessAction(this.entries);
}

class FetchInitialMoodLogsFailureAction {
  final String error;

  const FetchInitialMoodLogsFailureAction(this.error);
}

class SyncMoodLogsPartialSuccessAction {
  final List<MoodLogEntity> serverChanges;
  final List<MoodLogEntity> clientChanges;
  final DateTime newSyncTimestamp;
  final List<String> failedChunks;
  final int lastSuccessfulIndex;

  const SyncMoodLogsPartialSuccessAction({
    required this.serverChanges,
    required this.clientChanges,
    required this.newSyncTimestamp,
    required this.failedChunks,
    required this.lastSuccessfulIndex,
  });
}
