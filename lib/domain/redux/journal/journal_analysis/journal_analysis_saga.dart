import 'package:redux_saga/redux_saga.dart' as redux_saga;
import 'package:redux_saga/redux_saga.dart' hide Result, Select;
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/api/journal_analysis_api.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as journal_collection;
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/domain/redux/journal/journal_analysis/journal_analysis_actions.dart';
import 'package:cbl/cbl.dart' as cbl;

class JournalAnalysisSaga {
  final JournalAnalysisAPI _api = JournalAnalysisAPI();

  Iterable<void> saga() sync* {
    yield TakeEvery(_analyzeJournal, pattern: AnalyzeJournalAction);
  }

  _analyzeJournal({required AnalyzeJournalAction action}) sync* {
    try {
      var analysisResult = redux_saga.Result<Map<String, dynamic>>();
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
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
    yield Call(journalEntryRepository.getJournalEntryById, args: [journalEntryId], result: journalEntryResult);

    if (journalEntryResult.value != null) {
      journal_collection.JournalEntry existingEntry = journalEntryResult.value!;

      // Create a list of journal feelings
      List<journal_collection.JournalFeeling> feelings = (analysisResult['feelings'] as List<dynamic>)
          .map((feeling) => journal_collection.JournalFeeling(emoticon: feeling['emoticon'], title: feeling['title']))
          .toList();

      // Create a new journal entry with updated values
      journal_collection.JournalEntry updatedEntry = journal_collection.JournalEntry(
          id: existingEntry.id,
          templateId: existingEntry.templateId,
          timestamp: existingEntry.timestamp,
          createdAt: existingEntry.createdAt,
          updatedAt: DateTime.now(),
          questions: existingEntry.questions,
          textEntries: existingEntry.textEntries,
          voiceEntries: existingEntry.voiceEntries,
          videoEntries: existingEntry.videoEntries,
          imageEntries: existingEntry.imageEntries,
          bulletPointEntries: existingEntry.bulletPointEntries,
          painNoteEntries: existingEntry.painNoteEntries,
          urlMetadata: existingEntry.urlMetadata,
          metadata: existingEntry.metadata,
          lock: existingEntry.lock,
          emoticon: analysisResult['emoticon'],
          title: analysisResult['title'],
          body: existingEntry.body,
          summary: analysisResult['summary'],
          keyInsight: analysisResult['keyInsight'],
          affirmation: analysisResult['affirmation'],
          topics: (analysisResult['topics'] as List<dynamic>).cast<String>(),
          feelings: feelings,
          isDeleted: existingEntry.isDeleted);

      yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [updatedEntry]);
      yield Put(LoadJournalDetailAction(journalEntryId));
      yield Put(const SyncJournalEntries());
      yield Put(LoadJournalEntriesListAction(0, 3000));
    } else {
      yield Put(const AnalyzeJournalErrorAction("Journal entry not found."));
    }
  }
}
