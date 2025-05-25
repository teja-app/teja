import 'package:redux_saga/redux_saga.dart' as redux_saga;
import 'package:redux_saga/redux_saga.dart' hide Result, Select;
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:cbl/cbl.dart' as cbl;

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
      var cblResult = redux_saga.Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database cblDatabase = cblResult.value!;

      var journalEntriesResult = redux_saga.Result<List<JournalEntryEntity>>();
      yield Call(JournalEntryRepository(cblDatabase).getJournalEntriesPage,
          args: [action.pageKey, action.pageSize], result: journalEntriesResult);

      if (journalEntriesResult.value != null) {
        bool isLastPage = journalEntriesResult.value!.length < action.pageSize;
        yield Put(JournalEntriesListFetchedSuccessAction(journalEntriesResult.value!, isLastPage));
      } else {
        yield Put(JournalEntriesListFetchFailedAction('No journal entries found for the requested page.'));
      }
      // yield Put(const FetchJournalLogsAction());
    }, Catch: (e, s) sync* {
      yield Put(JournalEntriesListFetchFailedAction(e.toString()));
    });
  }
}
