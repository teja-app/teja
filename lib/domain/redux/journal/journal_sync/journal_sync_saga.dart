import 'package:redux_saga/redux_saga.dart';
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
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);
    print("_handleSyncJournalEntries:2");

    // Get the last sync timestamp
    var lastSyncTimestampResult = Result<DateTime?>();
    yield Call(journalEntryRepository.getLastSyncTimestamp, result: lastSyncTimestampResult);
    DateTime lastSyncTimestamp = lastSyncTimestampResult.value ?? DateTime.fromMillisecondsSinceEpoch(0);

    print("_handleSyncJournalEntries:3 ${lastSyncTimestamp}");
    // Get all local entries
    var localEntriesResult = Result<List<JournalEntryEntity>>();
    yield Call(journalEntryRepository.getAllJournalEntries, result: localEntriesResult);
    print("_handleSyncJournalEntries:4");
    List<JournalEntryEntity> localEntries = localEntriesResult.value!;

    print("_handleSyncJournalEntries:localEntries ${localEntries}");
    JournalEntryApiService api = JournalEntryApiService();

    // Sync with server
    var syncResultResult = Result<Map<String, List<JournalEntryEntity>>>();
    yield Call(api.syncEntries, args: [localEntries, lastSyncTimestamp], result: syncResultResult);
    var syncResult = syncResultResult.value!;

    // Process server changes
    yield Call(journalEntryRepository.addOrUpdateJournalEntries, args: [syncResult['serverChanges']]);

    // Process client changes
    yield Call(journalEntryRepository.addOrUpdateJournalEntries, args: [syncResult['clientChanges']]);

    // Update the last sync timestamp
    DateTime newSyncTimestamp = DateTime.now();
    yield Call(journalEntryRepository.updateLastSyncTimestamp, args: [newSyncTimestamp]);

    yield Put(
      SyncJournalEntriesSuccessAction(
        serverChanges: syncResult['serverChanges'] ?? [],
        clientChanges: syncResult['clientChanges'] ?? [],
        newSyncTimestamp: newSyncTimestamp,
      ),
    );
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
