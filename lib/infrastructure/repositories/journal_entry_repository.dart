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
