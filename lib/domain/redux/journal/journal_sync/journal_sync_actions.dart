import 'package:teja/domain/entities/journal_entry_entity.dart';

class SyncJournalEntries {
  const SyncJournalEntries();
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
