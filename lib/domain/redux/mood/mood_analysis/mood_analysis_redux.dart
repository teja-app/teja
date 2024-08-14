import 'package:redux/redux.dart';
import 'package:teja/domain/redux/mood/mood_analysis/mood_analysis_actions.dart';
import 'package:teja/domain/redux/mood/mood_analysis/mood_analysis_state.dart';

final Reducer<MoodAnalysisState> moodAnalysisReducer = combineReducers<MoodAnalysisState>([
  TypedReducer<MoodAnalysisState, AnalyzeMoodAction>(_analyzeMood),
  TypedReducer<MoodAnalysisState, AnalyzeMoodSuccessAction>(_analyzeMoodSuccess),
  TypedReducer<MoodAnalysisState, AnalyzeMoodErrorAction>(_analyzeMoodError),
]);

MoodAnalysisState _analyzeMood(MoodAnalysisState state, AnalyzeMoodAction action) {
  return state.copyWith(isAnalyzing: true, errorMessage: null);
}

MoodAnalysisState _analyzeMoodSuccess(MoodAnalysisState state, AnalyzeMoodSuccessAction action) {
  return state.copyWith(
    isAnalyzing: false,
    errorMessage: null,
  );
}

MoodAnalysisState _analyzeMoodError(MoodAnalysisState state, AnalyzeMoodErrorAction action) {
  return state.copyWith(
    isAnalyzing: false,
    errorMessage: action.errorMessage,
  );
}
