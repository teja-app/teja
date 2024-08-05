import 'package:teja/domain/entities/journal_entry_entity.dart';

class SyncJournalEntries {
  const SyncJournalEntries();
}

class SyncJournalEntriesPartialSuccessAction {
  final List<JournalEntryEntity> serverChanges;
  final List<JournalEntryEntity> clientChanges;
  final DateTime newSyncTimestamp;
  final List<String> failedChunks;
  final int lastSuccessfulIndex;

  SyncJournalEntriesPartialSuccessAction({
    required this.serverChanges,
    required this.clientChanges,
    required this.newSyncTimestamp,
    required this.failedChunks,
    required this.lastSuccessfulIndex,
  });
}

class SyncJournalEntriesSuccessAction {
  final List<JournalEntryEntity> serverChanges;
  final List<JournalEntryEntity> clientChanges;
  final DateTime newSyncTimestamp;

  const SyncJournalEntriesSuccessAction({
    required this.serverChanges,
    required this.clientChanges,
    required this.newSyncTimestamp,
  });
}

class SyncJournalEntriesFailureAction {
  final String error;

  const SyncJournalEntriesFailureAction(this.error);
}

class FetchInitialJournalEntriesAction {
  const FetchInitialJournalEntriesAction();
}

class FetchInitialJournalEntriesSuccessAction {
  final List<JournalEntryEntity> entries;

  const FetchInitialJournalEntriesSuccessAction(this.entries);
}

class FetchInitialJournalEntriesFailureAction {
  final String error;

  const FetchInitialJournalEntriesFailureAction(this.error);
}
