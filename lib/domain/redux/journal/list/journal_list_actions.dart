import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

abstract class JournalListAction {}

@immutable
class LoadJournalEntriesListAction extends JournalListAction {
  final int pageKey;
  final int pageSize;

  LoadJournalEntriesListAction(this.pageKey, this.pageSize);
}

@immutable
class ApplyJournalEntriesFilterAction extends JournalListAction {
  final DateTime startDate;
  final DateTime endDate;

  ApplyJournalEntriesFilterAction(this.startDate, this.endDate);
}

@immutable
class ResetJournalEntriesListAction extends JournalListAction {}

@immutable
class FetchJournalEntriesInProgressAction extends JournalListAction {}

@immutable
class JournalEntriesListFetchedSuccessAction extends JournalListAction {
  final List<JournalEntryEntity> journalEntries;
  final bool isLastPage;

  JournalEntriesListFetchedSuccessAction(this.journalEntries, this.isLastPage);
}

@immutable
class JournalEntriesListFetchFailedAction extends JournalListAction {
  final String errorMessage;

  JournalEntriesListFetchFailedAction(this.errorMessage);
}
