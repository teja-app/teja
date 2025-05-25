import 'package:redux_saga/redux_saga.dart' as redux_saga;
import 'package:redux_saga/redux_saga.dart' hide Result, Select;
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:cbl/cbl.dart' as cbl;

class JournalLogsSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchJournalLogs, pattern: FetchJournalLogsAction);
  }

  _fetchJournalLogs({dynamic action}) sync* {
    var cblResult = redux_saga.Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database cblDatabase = cblResult.value!;
    JournalEntryRepository journalEntryRepository = JournalEntryRepository(cblDatabase);

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month - 5);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    var journalLogs = redux_saga.Result<List<JournalEntryEntity>>();
    yield Call(journalEntryRepository.getJournalEntriesInDateRange,
        args: [startOfMonth, endOfMonth], result: journalLogs);

    if (journalLogs.value == null || journalLogs.value!.isEmpty) {
      yield Put(const FetchJournalLogsErrorAction("No journal entries found."));
      return;
    }

    final Map<DateTime, List<JournalEntryEntity>> journalLogsMap = {};
    for (var journalLog in journalLogs.value!) {
      DateTime logDate = DateTime(journalLog.timestamp.year, journalLog.timestamp.month, journalLog.timestamp.day);
      if (!journalLogsMap.containsKey(logDate)) {
        journalLogsMap[logDate] = [journalLog];
      } else {
        journalLogsMap[logDate]!.add(journalLog);
      }
    }

    yield Put(FetchJournalLogsSuccessAction(journalLogsMap));
  }
}
