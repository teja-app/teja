import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_actions.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_state.dart';

AISuggestionState _fetchAISuggestion(AISuggestionState state, FetchAISuggestionAction action) {
  return state.copyWith(
    isLoading: true,
    updateErrorMessage: true,
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
    updateErrorMessage: true,
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

AISuggestionState _fetchAITitle(AISuggestionState state, FetchAITitleAction action) {
  return state.copyWith(
    isLoading: true,
    updateErrorMessage: true,
    errorMessage: null,
  );
}

AISuggestionState _fetchAITitleSuccess(AISuggestionState state, FetchAITitleSuccessAction action) {
  final updatedMoodLogs = state.moodLogs.map((moodLog) {
    if (moodLog.id == action.moodId) {
      return moodLog.copyWith(
        ai: MoodLogAIEntity(title: action.title),
      );
    }
    return moodLog;
  }).toList();

  return state.copyWith(
    isLoading: false,
    moodLogs: updatedMoodLogs,
  );
}

AISuggestionState _fetchAITitleFailure(AISuggestionState state, FetchAITitleFailureAction action) {
  return state.copyWith(
    isLoading: false,
    updateErrorMessage: true,
    errorMessage: action.errorMessage,
  );
}

AISuggestionState _updateAITitle(AISuggestionState state, UpdateAITitleAction action) {
  final updatedMoodLogs = state.moodLogs.map((moodLog) {
    if (moodLog.id == action.moodId) {
      return moodLog.copyWith(
        ai: MoodLogAIEntity(title: action.title),
      );
    }
    return moodLog;
  }).toList();

  return state.copyWith(
    moodLogs: updatedMoodLogs,
  );
}

AISuggestionState _fetchAIAffirmation(AISuggestionState state, FetchAIAffirmationAction action) {
  return state.copyWith(
    isLoading: true,
    updateErrorMessage: true,
    errorMessage: null,
  );
}

AISuggestionState _fetchAIAffirmationSuccess(AISuggestionState state, FetchAIAffirmationSuccessAction action) {
  final updatedMoodLogs = state.moodLogs.map((moodLog) {
    if (moodLog.id == action.moodId) {
      return moodLog.copyWith(
        ai: MoodLogAIEntity(affirmation: action.affirmation),
      );
    }
    return moodLog;
  }).toList();

  return state.copyWith(
    isLoading: false,
    moodLogs: updatedMoodLogs,
  );
}

AISuggestionState _fetchAIAffirmationFailure(AISuggestionState state, FetchAIAffirmationFailureAction action) {
  return state.copyWith(
    isLoading: false,
    updateErrorMessage: true,
    errorMessage: action.errorMessage,
  );
}

AISuggestionState _updateAIAffirmation(AISuggestionState state, UpdateAIAffirmationAction action) {
  final updatedMoodLogs = state.moodLogs.map((moodLog) {
    if (moodLog.id == action.moodId) {
      return moodLog.copyWith(
        ai: MoodLogAIEntity(affirmation: action.affirmation),
      );
    }
    return moodLog;
  }).toList();

  return state.copyWith(
    moodLogs: updatedMoodLogs,
  );
}

AISuggestionState _clearErrorMessages(AISuggestionState state, ClearErrorMessagesAction action) {
  return state.copyWith(
    updateErrorMessage: true,
    errorMessage: null,
  );
}

Reducer<AISuggestionState> aiSuggestionReducer = combineReducers<AISuggestionState>([
  TypedReducer<AISuggestionState, FetchAISuggestionAction>(_fetchAISuggestion),
  TypedReducer<AISuggestionState, FetchAISuggestionSuccessAction>(_fetchAISuggestionSuccess),
  TypedReducer<AISuggestionState, FetchAISuggestionFailureAction>(_fetchAISuggestionFailure),
  TypedReducer<AISuggestionState, UpdateAISuggestionAction>(_updateAISuggestion),
  TypedReducer<AISuggestionState, FetchAITitleAction>(_fetchAITitle),
  TypedReducer<AISuggestionState, FetchAITitleSuccessAction>(_fetchAITitleSuccess),
  TypedReducer<AISuggestionState, FetchAITitleFailureAction>(_fetchAITitleFailure),
  TypedReducer<AISuggestionState, UpdateAITitleAction>(_updateAITitle),
  TypedReducer<AISuggestionState, FetchAIAffirmationAction>(_fetchAIAffirmation),
  TypedReducer<AISuggestionState, FetchAIAffirmationSuccessAction>(_fetchAIAffirmationSuccess),
  TypedReducer<AISuggestionState, FetchAIAffirmationFailureAction>(_fetchAIAffirmationFailure),
  TypedReducer<AISuggestionState, UpdateAIAffirmationAction>(_updateAIAffirmation),
  TypedReducer<AISuggestionState, ClearErrorMessagesAction>(_clearErrorMessages),
]);
