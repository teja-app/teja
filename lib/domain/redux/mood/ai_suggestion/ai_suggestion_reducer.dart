import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_state.dart';

AISuggestionState _fetchAISuggestion(AISuggestionState state, FetchAISuggestionAction action) {
  return state.copyWith(
    isLoading: true,
    errorMessage: null,
  );
}

AISuggestionState _fetchAISuggestionSuccess(AISuggestionState state, FetchAISuggestionSuccessAction action) {
  final updatedMoodLogs = state.moodLogs.map((moodLog) {
    if (moodLog.id == action.moodId) {
      return moodLog.copyWith(
        ai: MoodLogAIEntity(suggestion: action.suggestion),
      );
    }
    return moodLog;
  }).toList();

  return state.copyWith(
    isLoading: false,
    moodLogs: updatedMoodLogs,
  );
}

AISuggestionState _fetchAISuggestionFailure(AISuggestionState state, FetchAISuggestionFailureAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.errorMessage,
  );
}

AISuggestionState _updateAISuggestion(AISuggestionState state, UpdateAISuggestionAction action) {
  final updatedMoodLogs = state.moodLogs.map((moodLog) {
    if (moodLog.id == action.moodId) {
      return moodLog.copyWith(
        ai: MoodLogAIEntity(suggestion: action.suggestion),
      );
    }
    return moodLog;
  }).toList();

  return state.copyWith(
    moodLogs: updatedMoodLogs,
  );
}

Reducer<AISuggestionState> aiSuggestionReducer = combineReducers<AISuggestionState>([
  TypedReducer<AISuggestionState, FetchAISuggestionAction>(_fetchAISuggestion),
  TypedReducer<AISuggestionState, FetchAISuggestionSuccessAction>(_fetchAISuggestionSuccess),
  TypedReducer<AISuggestionState, FetchAISuggestionFailureAction>(_fetchAISuggestionFailure),
  TypedReducer<AISuggestionState, UpdateAISuggestionAction>(_updateAISuggestion),
]);
