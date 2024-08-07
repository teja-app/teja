import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/infrastructure/api/journal_analysis_api.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/domain/redux/journal/journal_analysis/journal_analysis_actions.dart';
import 'package:isar/isar.dart';

class JournalAnalysisSaga {
  final JournalAnalysisAPI _api = JournalAnalysisAPI();

  Iterable<void> saga() sync* {
    yield TakeEvery(_analyzeJournal, pattern: AnalyzeJournalAction);
  }

  _analyzeJournal({required AnalyzeJournalAction action}) sync* {
    try {
      var analysisResult = Result<Map<String, dynamic>>();
      yield Call(_api.analyzeJournal, args: [action.journalEntryId], result: analysisResult);

      if (analysisResult.value != null) {
        yield Put(AnalyzeJournalSuccessAction(action.journalEntryId, analysisResult.value!));

        // Update the journal entry with the analysis results
        yield Call(_updateJournalEntry, args: [action.journalEntryId, analysisResult.value!]);
      } else {
        yield Put(const AnalyzeJournalErrorAction("Failed to analyze journal."));
      }
    } catch (e) {
      yield Put(AnalyzeJournalErrorAction(e.toString()));
    }
  }

  _updateJournalEntry(String journalEntryId, Map<String, dynamic> analysisResult) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    JournalEntryRepository repository = JournalEntryRepository(isar);

    var journalEntryResult = Result<JournalEntry?>();
    yield Call(repository.getJournalEntryById, args: [journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      JournalEntry existingEntry = journalEntryResult.value!;
      existingEntry
        ..emoticon = analysisResult['emoticon']
        ..title = analysisResult['title']
        ..summary = analysisResult['summary']
        ..keyInsight = analysisResult['keyInsight']
        ..feelings = (analysisResult['feelings'] as List<dynamic>)
            .map((feeling) => JournalFeeling()
              ..emoticon = feeling['emoticon']
              ..title = feeling['title'])
            .toList()
        ..topics = (analysisResult['topics'] as List<dynamic>).cast<String>()
        ..affirmation = analysisResult['affirmation']
        ..updatedAt = DateTime.now(); // Set the updated timestamp

      yield Call(repository.addOrUpdateJournalEntry, args: [existingEntry]);
      yield Put(LoadJournalDetailAction(journalEntryId));
      yield Put(const SyncJournalEntries());
    } else {
      yield Put(const AnalyzeJournalErrorAction("Journal entry not found."));
    }
  }
}
