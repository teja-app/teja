import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class LoadJournalDetailAction {
  final String journalEntryId;
  const LoadJournalDetailAction(this.journalEntryId);
}

@immutable
class LoadJournalDetailSuccessAction {
  final JournalEntryEntity journalEntry;
  const LoadJournalDetailSuccessAction(this.journalEntry);
}

@immutable
class LoadJournalDetailFailureAction {
  final String errorMessage;
  const LoadJournalDetailFailureAction(this.errorMessage);
}

@immutable
class DeleteJournalDetailAction {
  final String journalEntryId;
  const DeleteJournalDetailAction(this.journalEntryId);
}

@immutable
class DeleteJournalDetailSuccessAction {
  const DeleteJournalDetailSuccessAction();
}

@immutable
class DeleteJournalDetailFailureAction {
  final String errorMessage;
  const DeleteJournalDetailFailureAction(this.errorMessage);
}
