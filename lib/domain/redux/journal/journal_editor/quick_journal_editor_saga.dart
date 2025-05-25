import 'package:redux_saga/redux_saga.dart' as redux_saga;
import 'package:redux_saga/redux_saga.dart' hide Result, Select;
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as journal_collection;
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:cbl/cbl.dart' as cbl;
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:teja/shared/helpers/logger.dart';

class QuickJournalEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleInitializeQuickJournalEditor, pattern: InitializeQuickJournalEditor);
  }

  _handleInitializeQuickJournalEditor({required InitializeQuickJournalEditor action}) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    yield Try(() sync* {
      JournalEntryEntity? journalEntryEntity;
      if (action.journalEntryId != null) {
        var journalEntryResult = redux_saga.Result<journal_collection.JournalEntry?>();
        yield Call(journalEntryRepository.getJournalEntryById,
            args: [action.journalEntryId], result: journalEntryResult);
        if (journalEntryResult.value != null) {
          journalEntryEntity = journalEntryRepository.toEntity(journalEntryResult.value!);
        }
      }

      if (journalEntryEntity == null) {
        bool unique = false;
        while (!unique) {
          try {
            DateTime now = DateTime.now();
            String newId = Helpers.generateUniqueId();

            // Create the journal entry using the factory constructor
            journal_collection.JournalEntry newJournalEntry = journal_collection.JournalEntry(
                id: newId,
                timestamp: now,
                createdAt: now,
                updatedAt: now,
                questions: [],
                textEntries: [],
                voiceEntries: [],
                videoEntries: [],
                imageEntries: [],
                bulletPointEntries: [],
                painNoteEntries: [],
                metadata: journal_collection.JournalEntryMetadata(tags: []),
                lock: false,
                title: '',
                isDeleted: false);

            yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [newJournalEntry]);
            journalEntryEntity = journalEntryRepository.toEntity(newJournalEntry);
            unique = true;
          } catch (e) {
            if (e.toString().contains('Unique index violated')) {
              logger.e("Unique index violated, generating a new ID.");
            } else {
              rethrow;
            }
          }
        }
      }

      yield Put(InitializeQuickJournalEditorSuccessAction(journalEntryEntity!));
    }, Catch: (e, s) sync* {
      logger.e("InitializeQuickJournalEditorFailureAction", error: e, stackTrace: s);
      yield Put(InitializeQuickJournalEditorFailureAction(e.toString()));
    });
  }
}
