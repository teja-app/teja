import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

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
      {DateTime? startDate, DateTime? endDate}) async {
    final startIndex = pageKey * pageSize;

    var filterConditions = <FilterCondition>[];

    // Example filter condition based on a hypothetical date range
    if (startDate != null && endDate != null) {
      filterConditions.add(FilterCondition.between(
        property: 'timestamp',
        lower: startDate,
        upper: endDate,
      ));
    }

    final query = isar.journalEntrys.buildQuery(
      filter: filterConditions.isNotEmpty ? FilterGroup.and(filterConditions) : null,
      sortBy: [const SortProperty(property: 'timestamp', sort: Sort.desc)],
      offset: startIndex,
      limit: pageSize,
    );

    final journalEntries = await query.findAll();

    return journalEntries.map((moodLog) => toEntity(moodLog)).toList();
  }

  Future<List<JournalEntry>> getJournalEntriesInDateRange(DateTime start, DateTime end) async {
    try {
      // Fetch entries between the specified start and end dates
      final List<JournalEntry> entries = await isar.journalEntrys.filter().timestampBetween(start, end).findAll();

      return entries;
    } catch (e) {
      rethrow; // Propagate any errors for handling in the saga or higher-level logic
    }
  }

  JournalEntryEntity toEntity(JournalEntry journalEntry) {
    return JournalEntryEntity(
      id: journalEntry.id,
      templateId: journalEntry.templateId,
      timestamp: journalEntry.timestamp,
      createdAt: journalEntry.createdAt,
      updatedAt: journalEntry.updatedAt,
      questions: journalEntry.questions
          ?.map((q) => QuestionAnswerPairEntity(
                questionId: q.questionId,
                questionText: q.questionText,
                answerText: q.answerText,
              ))
          .toList(),
    );
  }
}
