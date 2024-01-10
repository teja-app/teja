import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_state.dart';

final Reducer<JournalLogsState> journalLogsReducer = combineReducers<JournalLogsState>([
  TypedReducer<JournalLogsState, FetchJournalLogsAction>(_fetchJournalLogs),
  TypedReducer<JournalLogsState, FetchJournalLogsSuccessAction>(_fetchJournalLogsSuccess),
  TypedReducer<JournalLogsState, FetchJournalLogsErrorAction>(_fetchJournalLogsError),
]);

JournalLogsState _fetchJournalLogs(JournalLogsState state, FetchJournalLogsAction action) {
  return state.copyWith(isFetching: true);
}

JournalLogsState _fetchJournalLogsSuccess(JournalLogsState state, FetchJournalLogsSuccessAction action) {
  Map<String, List<JournalEntryEntity>> stringKeyedMap = action.journalLogs.map((key, value) {
    return MapEntry(DateFormat('yyyy-MM-dd').format(key), value);
  });

  return state.copyWith(
    journalLogsByDate: stringKeyedMap,
    isFetching: false,
    fetchSuccess: true,
  );
}

JournalLogsState _fetchJournalLogsError(JournalLogsState state, FetchJournalLogsErrorAction action) {
  return state.copyWith(
    journalLogsByDate: const {},
    isFetching: false,
    errorMessage: action.errorMessage,
  );
}
