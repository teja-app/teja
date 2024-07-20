import 'package:redux/redux.dart';
import 'package:teja/domain/redux/journal/journal_analysis/journal_analysis_actions.dart';
import 'package:teja/domain/redux/journal/journal_analysis/journal_analysis_state.dart';

final Reducer<JournalAnalysisState> journalAnalysisReducer = combineReducers<JournalAnalysisState>([
  TypedReducer<JournalAnalysisState, AnalyzeJournalAction>(_analyzeJournal),
  TypedReducer<JournalAnalysisState, AnalyzeJournalSuccessAction>(_analyzeJournalSuccess),
  TypedReducer<JournalAnalysisState, AnalyzeJournalErrorAction>(_analyzeJournalError),
]);

JournalAnalysisState _analyzeJournal(JournalAnalysisState state, AnalyzeJournalAction action) {
  return state.copyWith(isAnalyzing: true, errorMessage: null);
}

JournalAnalysisState _analyzeJournalSuccess(JournalAnalysisState state, AnalyzeJournalSuccessAction action) {
  return state.copyWith(
    isAnalyzing: false,
    errorMessage: null,
  );
}

JournalAnalysisState _analyzeJournalError(JournalAnalysisState state, AnalyzeJournalErrorAction action) {
  return state.copyWith(
    isAnalyzing: false,
    errorMessage: action.errorMessage,
  );
}
