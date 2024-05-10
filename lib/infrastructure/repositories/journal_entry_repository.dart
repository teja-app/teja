import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository_helpers.dart';

class JournalEntryRepository {
  final Isar isar;

  JournalEntryRepository(this.isar);

  Future<JournalEntry?> getJournalEntryById(String? id) async {
    return isar.journalEntrys.getById(id!);
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    return isar.journalEntrys.where().findAll();
  }

  Future<void> addOrUpdateJournalEntry(JournalEntry journalEntry) async {
    await isar.writeTxn(() async {
      journalEntry.updatedAt = DateTime.now();
      await isar.journalEntrys.put(journalEntry);
    });
  }

  Future<void> deleteJournalEntryById(String? id) async {
    await isar.writeTxn(() async {
      await isar.journalEntrys.deleteById(id!);
    });
  }

  Future<List<JournalEntryEntity>> getJournalEntriesPage(int pageKey, int pageSize,
      {DateTime? startDate, DateTime? endDate}) {
    return getJournalEntriesPageHelper(isar, pageKey, pageSize, startDate: startDate, endDate: endDate);
  }

  Future<List<JournalEntry>> getJournalEntriesInDateRange(DateTime start, DateTime end) {
    return getJournalEntriesInDateRangeHelper(isar, start, end);
  }

  JournalEntryEntity toEntity(JournalEntry journalEntry) {
    return toEntityHelper(journalEntry);
  }
}
