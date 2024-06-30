import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';
import 'package:teja/shared/helpers/logger.dart';

class QuickJournalEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleInitializeQuickJournalEditor, pattern: InitializeQuickJournalEditor);
  }

  _handleInitializeQuickJournalEditor({required InitializeQuickJournalEditor action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    yield Try(() sync* {
      JournalEntryEntity? journalEntryEntity;
      if (action.journalEntryId != null) {
        var journalEntryResult = Result<JournalEntry>();
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
            final newJournalEntry = JournalEntry()
              ..id = Helpers.generateUniqueId()
              ..timestamp = DateTime.now()
              ..createdAt = DateTime.now()
              ..updatedAt = DateTime.now()
              ..questions = []
              ..textEntries = []
              ..voiceEntries = []
              ..videoEntries = []
              ..imageEntries = []
              ..bulletPointEntries = []
              ..painNoteEntries = []
              ..metadata = (JournalEntryMetadata()..tags = [])
              ..lock = false
              ..title = '';

            yield Call(journalEntryRepository.addOrUpdateJournalEntry, args: [newJournalEntry]);
            journalEntryEntity = journalEntryRepository.toEntity(newJournalEntry);
            unique = true;
          } catch (e) {
            if (e.toString().contains('Unique index violated')) {
              logger.e("Unique index violated, generating a new ID.");
            } else {
              throw e;
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
