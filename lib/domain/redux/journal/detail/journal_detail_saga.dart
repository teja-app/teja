import 'package:redux_saga/redux_saga.dart' as redux_saga;
import 'package:redux_saga/redux_saga.dart' hide Result, Select;
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as journal_collection;
import 'package:cbl/cbl.dart' as cbl;

class JournalDetailSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_loadJournalDetail, pattern: LoadJournalDetailAction);
    yield TakeEvery(_deleteJournalDetail, pattern: DeleteJournalDetailAction);
  }

  _loadJournalDetail({required LoadJournalDetailAction action}) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    var journalEntryRepository = JournalEntryRepository(cblDatabase);
    yield Try(() sync* {
      var journalEntry = redux_saga.Result<journal_collection.JournalEntry?>();
      yield Call(
        journalEntryRepository.getJournalEntryById,
        args: [action.journalEntryId],
        result: journalEntry,
      );

      if (journalEntry.value != null) {
        if (journalEntry.value!.isDeleted) {
          yield Put(const LoadJournalDetailFailureAction('Journal entry has been deleted.'));
        } else {
          yield Put(LoadJournalDetailSuccessAction(journalEntryRepository.toEntity(journalEntry.value!)));
        }
      } else {
        yield Put(const LoadJournalDetailFailureAction('No journal entry found.'));
      }
    }, Catch: (e, s) sync* {
      yield Put(LoadJournalDetailFailureAction(e.toString()));
    });
  }

  _deleteJournalDetail({required DeleteJournalDetailAction action}) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;

    var journalEntryRepository = JournalEntryRepository(cblDatabase);

    yield Try(() sync* {
      yield Call(journalEntryRepository.softDeleteJournalEntry, args: [action.journalEntryId]);
      yield Put(const DeleteJournalDetailSuccessAction());
      yield Put(const SyncJournalEntries());
      // Refresh the journal entries list
      yield Put(ResetJournalEntriesListAction());
      yield Put(LoadJournalEntriesListAction(0, 3000));
    }, Catch: (e, s) sync* {
      yield Put(DeleteJournalDetailFailureAction(e.toString()));
    });
  }
}
