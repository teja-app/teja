import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';

class JournalListSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchJournalEntries, pattern: LoadJournalEntriesListAction);
    yield TakeEvery(_applyJournalEntriesFilter, pattern: ApplyJournalEntriesFilterAction);
  }

  _applyJournalEntriesFilter({required ApplyJournalEntriesFilterAction action}) sync* {
    // Potentially apply filters here. Example:
    yield Put(LoadJournalEntriesListAction(0, 10)); // Reload with filters
  }

  _fetchJournalEntries({required LoadJournalEntriesListAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var journalEntriesResult = Result<List<JournalEntryEntity>>();
      yield Call(JournalEntryRepository(isar).getJournalEntriesPage,
          args: [action.pageKey, action.pageSize], result: journalEntriesResult);

      if (journalEntriesResult.value != null) {
        bool isLastPage = journalEntriesResult.value!.length < action.pageSize;
        yield Put(JournalEntriesListFetchedSuccessAction(journalEntriesResult.value!, isLastPage));
      } else {
        yield Put(JournalEntriesListFetchFailedAction('No journal entries found for the requested page.'));
      }
      yield Put(const FetchJournalLogsAction());
    }, Catch: (e, s) sync* {
      yield Put(JournalEntriesListFetchFailedAction(e.toString()));
    });
  }
}
