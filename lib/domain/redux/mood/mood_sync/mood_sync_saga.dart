import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/mood_sync/mood_sync_actions.dart';
import 'package:teja/infrastructure/api/mood_log_api.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:isar/isar.dart';

class MoodSyncSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleSyncMoodLogs, pattern: SyncMoodLogs);
    yield TakeEvery(_handleFetchInitialMoodLogs, pattern: FetchInitialMoodLogsAction);
  }

  _handleSyncMoodLogs({required SyncMoodLogs action}) sync* {
    try {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var moodLogRepository = MoodLogRepository(isar);

      var lastSyncTimestampResult = Result<DateTime?>();
      yield Call(moodLogRepository.getLastSyncTimestamp, result: lastSyncTimestampResult);
      DateTime lastSyncTimestamp = lastSyncTimestampResult.value ?? DateTime.fromMillisecondsSinceEpoch(0);

      var localEntriesResult = Result<List<MoodLogEntity>>();
      yield Call(moodLogRepository.getAllMoodLogs, result: localEntriesResult);
      List<MoodLogEntity> localEntries = localEntriesResult.value!;

      var previousFailedChunksResult = Result<List<String>?>();
      yield Call(moodLogRepository.getPreviousFailedChunks, result: previousFailedChunksResult);
      List<String>? previousFailedChunks = previousFailedChunksResult.value;

      MoodLogApiService api = MoodLogApiService();

      var syncResultResult = Result<Map<String, dynamic>>();
      yield Call(
        api.syncEntries,
        args: [localEntries, lastSyncTimestamp, previousFailedChunks],
        result: syncResultResult,
      );
      var syncResult = syncResultResult.value!;

      if (syncResult['serverChanges'].isNotEmpty) {
        yield Call(moodLogRepository.addOrUpdateMoodLogs, args: [syncResult['serverChanges']]);
      }

      if (syncResult['clientChanges'].isNotEmpty) {
        yield Call(moodLogRepository.addOrUpdateMoodLogs, args: [syncResult['clientChanges']]);
      }

      if (syncResult['failedChunks'].isEmpty) {
        yield Call(moodLogRepository.clearFailedChunks);
        DateTime newSyncTimestamp = DateTime.now();
        yield Call(moodLogRepository.updateLastSyncTimestamp, args: [newSyncTimestamp]);
        yield Put(SyncMoodLogsSuccessAction(
          serverChanges: syncResult['serverChanges'],
          clientChanges: syncResult['clientChanges'],
          newSyncTimestamp: newSyncTimestamp,
        ));
      } else {
        yield Call(moodLogRepository.storeFailedChunks, args: [syncResult['failedChunks']]);
        yield Call(moodLogRepository.updateLastSyncTimestamp, args: [lastSyncTimestamp]);
        yield Put(SyncMoodLogsPartialSuccessAction(
          serverChanges: syncResult['serverChanges'],
          clientChanges: syncResult['clientChanges'],
          newSyncTimestamp: lastSyncTimestamp,
          failedChunks: syncResult['failedChunks'],
          lastSuccessfulIndex: syncResult['lastSuccessfulIndex'],
        ));
      }
    } catch (error) {
      yield Put(SyncMoodLogsFailureAction(error.toString()));
    }
  }

  _handleFetchInitialMoodLogs({required FetchInitialMoodLogsAction action}) sync* {
    try {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var moodLogRepository = MoodLogRepository(isar);
      MoodLogApiService api = MoodLogApiService();

      // Fetch all entries from the server
      var entriesResult = Result<List<MoodLogEntity>>();
      yield Call(api.getAllEntries, args: [], namedArgs: {#includeDeleted: true}, result: entriesResult);
      List<MoodLogEntity> entries = entriesResult.value!;

      // Save all entries to local storage
      yield Call(moodLogRepository.addOrUpdateMoodLogs, args: [entries]);

      // // Update the last sync timestamp
      DateTime newSyncTimestamp = DateTime.now();
      yield Call(moodLogRepository.updateLastSyncTimestamp, args: [newSyncTimestamp]);

      yield Put(FetchInitialMoodLogsSuccessAction(entries));
    } catch (error) {
      yield Put(FetchInitialMoodLogsFailureAction(error.toString()));
    }
  }
}
