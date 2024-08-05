import 'package:redux_saga/redux_saga.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/infrastructure/api/journal_entry_api.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:isar/isar.dart';

class JournalSyncSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleSyncJournalEntries, pattern: SyncJournalEntries);
    yield TakeEvery(_handleFetchInitialJournalEntries, pattern: FetchInitialJournalEntriesAction);
  }

  _handleSyncJournalEntries({required SyncJournalEntries action}) sync* {
    try {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var journalEntryRepository = JournalEntryRepository(isar);

      var lastSyncTimestampResult = Result<DateTime?>();
      yield Call(journalEntryRepository.getLastSyncTimestamp, result: lastSyncTimestampResult);
      DateTime lastSyncTimestamp = lastSyncTimestampResult.value ?? DateTime.fromMillisecondsSinceEpoch(0);

      var localEntriesResult = Result<List<JournalEntryEntity>>();
      yield Call(journalEntryRepository.getAllJournalEntries, result: localEntriesResult);
      List<JournalEntryEntity> localEntries = localEntriesResult.value!;

      var previousFailedChunksResult = Result<List<String>?>();
      yield Call(_getPreviousFailedChunks, result: previousFailedChunksResult);
      List<String>? previousFailedChunks = previousFailedChunksResult.value;

      JournalEntryApiService api = JournalEntryApiService();

      var syncResultResult = Result<Map<String, dynamic>>();
      yield Call(api.syncEntries,
          args: [localEntries, lastSyncTimestamp, previousFailedChunks], result: syncResultResult);
      var syncResult = syncResultResult.value!;

      if (syncResult['serverChanges'].isNotEmpty) {
        yield Call(journalEntryRepository.addOrUpdateJournalEntries, args: [syncResult['serverChanges']]);
      }

      if (syncResult['clientChanges'].isNotEmpty) {
        yield Call(journalEntryRepository.addOrUpdateJournalEntries, args: [syncResult['clientChanges']]);
      }

      if (syncResult['failedChunks'].isEmpty) {
        yield Call(_clearFailedChunks);
        yield Call(journalEntryRepository.updateLastSyncTimestamp, args: [DateTime.now()]);
        yield Put(SyncJournalEntriesSuccessAction(
          serverChanges: syncResult['serverChanges'],
          clientChanges: syncResult['clientChanges'],
          newSyncTimestamp: DateTime.now(),
        ));
      } else {
        yield Call(_storeFailedChunks, args: [syncResult['failedChunks']]);
        yield Call(journalEntryRepository.updateLastSyncTimestamp, args: [lastSyncTimestamp]);
        yield Put(SyncJournalEntriesPartialSuccessAction(
          serverChanges: syncResult['serverChanges'],
          clientChanges: syncResult['clientChanges'],
          newSyncTimestamp: lastSyncTimestamp,
          failedChunks: syncResult['failedChunks'],
          lastSuccessfulIndex: syncResult['lastSuccessfulIndex'],
        ));
      }
    } catch (error) {
      yield Put(SyncJournalEntriesFailureAction(error.toString()));
    }
  }

  Future<List<String>?> _getPreviousFailedChunks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('failedChunks');
  }

  Future<void> _storeFailedChunks(List<String> failedChunks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('failedChunks', failedChunks);
  }

  Future<void> _clearFailedChunks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('failedChunks');
  }

  _handleFetchInitialJournalEntries({required FetchInitialJournalEntriesAction action}) sync* {
    try {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var journalEntryRepository = JournalEntryRepository(isar);
      JournalEntryApiService api = JournalEntryApiService();

      // Fetch all entries from the server
      var entriesResult = Result<List<JournalEntryEntity>>();
      yield Call(api.getAllEntries, result: entriesResult);
      List<JournalEntryEntity> entries = entriesResult.value!;

      // Save all entries to local storage
      yield Call(journalEntryRepository.addOrUpdateJournalEntries, args: [entries]);

      // Update the last sync timestamp
      yield Call(journalEntryRepository.updateLastSyncTimestamp, args: [DateTime.now()]);

      yield Put(FetchInitialJournalEntriesSuccessAction(entries));
    } catch (error) {
      yield Put(FetchInitialJournalEntriesFailureAction(error.toString()));
    }
  }
}
