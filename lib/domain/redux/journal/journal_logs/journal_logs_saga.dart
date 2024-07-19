import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';

class JournalLogsSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchJournalLogs, pattern: FetchJournalLogsAction);
  }

  _fetchJournalLogs({dynamic action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;
    JournalEntryRepository journalEntryRepository = JournalEntryRepository(isar);

    yield Try(() sync* {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month - 5);
      final endOfMonth = DateTime(now.year, now.month + 1, 1);
      var journalLogs = Result<List<JournalEntryEntity>>();
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
    }, Catch: (e, s) sync* {
      yield Put(FetchJournalLogsErrorAction(e.toString()));
    });
  }
}
