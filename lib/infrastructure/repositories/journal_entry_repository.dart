import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository_helpers.dart';

class JournalEntryRepository {
  final Isar isar;
  static const String LAST_SYNC_KEY = 'last_journal_sync_timestamp';

  JournalEntryRepository(this.isar);

  Future<JournalEntry?> getJournalEntryById(String? id) async {
    return isar.journalEntrys.getById(id!);
  }

  Future<List<JournalEntryEntity>> getAllJournalEntries({bool includeDeleted = false}) async {
    final query = isar.journalEntrys.where();
    if (!includeDeleted) {
      query.filter().isDeletedEqualTo(false);
    }
    List<JournalEntry> journalEntries = await query.findAll();
    return journalEntries.map((entry) => toEntityHelper(entry)).toList();
  }

  Future<void> addOrUpdateJournalEntry(JournalEntry journalEntry) async {
    await isar.writeTxn(() async {
      journalEntry.updatedAt = DateTime.now();
      await isar.journalEntrys.put(journalEntry);
    });
  }

  Future<void> softDeleteJournalEntry(String id) async {
    await isar.writeTxn(() async {
      final entry = await isar.journalEntrys.getById(id);
      if (entry != null) {
        entry.isDeleted = true;
        entry.updatedAt = DateTime.now();
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<void> addOrUpdateJournalEntries(List<JournalEntryEntity> entries) async {
    await isar.writeTxn(() async {
      for (var entry in entries) {
        final journalEntry = fromEntity(entry);

        // Check if an entry with this ID already exists
        final existingEntry = await isar.journalEntrys.getById(journalEntry.id);

        if (existingEntry != null) {
          // If it exists, update it only if the new entry is more recent
          if (journalEntry.updatedAt.isAfter(existingEntry.updatedAt)) {
            journalEntry.isarId = existingEntry.isarId; // Preserve the Isar ID
            await isar.journalEntrys.put(journalEntry);
          }
        } else {
          // If it doesn't exist, add it as a new entry
          await isar.journalEntrys.put(journalEntry);
        }
      }
    });
  }

  Future<void> deleteJournalEntryById(String? id) async {
    await isar.writeTxn(() async {
      await isar.journalEntrys.deleteById(id!);
    });
  }

  Future<List<JournalEntryEntity>> getJournalEntriesPage(
    int pageKey,
    int pageSize, {
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) {
    return getJournalEntriesPageHelper(
      isar,
      pageKey,
      pageSize,
      startDate: startDate,
      endDate: endDate,
      includeDeleted: includeDeleted,
    );
  }

  Future<List<JournalEntryEntity>> getJournalEntriesInDateRange(
    DateTime start,
    DateTime end, {
    bool includeDeleted = false,
  }) {
    return getJournalEntriesInDateRangeHelper(isar, start, end, includeDeleted: includeDeleted);
  }

  JournalEntryEntity toEntity(JournalEntry journalEntry) {
    return toEntityHelper(journalEntry);
  }

  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_SYNC_KEY, timestamp.toIso8601String());
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestampString = prefs.getString(LAST_SYNC_KEY);
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }
}
