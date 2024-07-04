import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class InitializeQuickJournalEditor {
  final String? journalEntryId;

  const InitializeQuickJournalEditor({this.journalEntryId});
}

@immutable
class InitializeQuickJournalEditorSuccessAction {
  final JournalEntryEntity journalEntry;

  const InitializeQuickJournalEditorSuccessAction(this.journalEntry);
}

@immutable
class InitializeQuickJournalEditorFailureAction {
  final String error;

  const InitializeQuickJournalEditorFailureAction(this.error);
}
