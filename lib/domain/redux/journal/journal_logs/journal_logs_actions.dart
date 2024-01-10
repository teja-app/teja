import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class FetchJournalLogsAction {
  const FetchJournalLogsAction();
}

@immutable
class FetchJournalLogsSuccessAction {
  final Map<DateTime, List<JournalEntryEntity>> journalLogs;

  const FetchJournalLogsSuccessAction(this.journalLogs);
}

@immutable
class FetchJournalLogsErrorAction {
  final String errorMessage;

  const FetchJournalLogsErrorAction(this.errorMessage);
}
