import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart' as journal_collection;

class JournalDetailSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_loadJournalDetail, pattern: LoadJournalDetailAction);
    yield TakeEvery(_deleteJournalDetail, pattern: DeleteJournalDetailAction);
  }

  _loadJournalDetail({required LoadJournalDetailAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);
    yield Try(() sync* {
      var journalEntry = Result<journal_collection.JournalEntry?>();
      yield Call(
        journalEntryRepository.getJournalEntryById,
        args: [action.journalEntryId],
        result: journalEntry,
      );

      if (journalEntry.value != null) {
        yield Put(LoadJournalDetailSuccessAction(journalEntryRepository.toEntity(journalEntry.value!)));
      } else {
        yield Put(const LoadJournalDetailFailureAction('No journal entry found.'));
      }
    }, Catch: (e, s) sync* {
      yield Put(LoadJournalDetailFailureAction(e.toString()));
    });
  }

  _deleteJournalDetail({required DeleteJournalDetailAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var journalEntryRepository = JournalEntryRepository(isar);

    yield Try(() sync* {
      yield Call(journalEntryRepository.deleteJournalEntryById, args: [action.journalEntryId]);
      yield Put(const DeleteJournalDetailSuccessAction());
    }, Catch: (e, s) sync* {
      yield Put(DeleteJournalDetailFailureAction(e.toString()));
    });
  }
}
