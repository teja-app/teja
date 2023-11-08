import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';

AppState _loadMoodDetail(AppState state, LoadMoodDetailAction action) {
  // Begin loading the mood detail
  return state.copyWith(
    moodDetailPage: state.moodDetailPage.copyWith(
      isLoading: true,
      errorMessage: null,
    ),
  );
}

AppState _setMoodDetail(AppState state, LoadMoodDetailSuccessAction action) {
  // Mood detail successfully loaded
  return state.copyWith(
    moodDetailPage: state.moodDetailPage.copyWith(
      selectedMoodLog: action.moodLog,
      isLoading: false,
    ),
  );
}

AppState _moodDetailError(AppState state, LoadMoodDetailFailureAction action) {
  // An error occurred
  return state.copyWith(
    moodDetailPage: MoodDetailState.initialState().copyWith(
      isLoading: false,
      errorMessage: action.errorMessage,
    ),
  );
}

// Reducer functions for delete actions
AppState _deleteMoodDetail(AppState state, DeleteMoodDetailAction action) {
  // Handle the deletion state changes if needed, e.g., show loading indicator
  return state;
}

AppState _deleteMoodDetailSuccess(
    AppState state, DeleteMoodDetailSuccessAction action) {
  // Successfully deleted, so you may want to reset the mood detail state or perform other state changes
  return state.copyWith(
    moodDetailPage: MoodDetailState.initialState(),
  );
}

AppState _deleteMoodDetailError(
    AppState state, DeleteMoodDetailFailureAction action) {
  // Handle the error state
  return state.copyWith(
    moodDetailPage: state.moodDetailPage.copyWith(
      errorMessage: action.errorMessage,
    ),
  );
}

final moodDetailReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, LoadMoodDetailAction>(_loadMoodDetail),
  TypedReducer<AppState, LoadMoodDetailSuccessAction>(_setMoodDetail),
  TypedReducer<AppState, LoadMoodDetailFailureAction>(_moodDetailError),
  TypedReducer<AppState, DeleteMoodDetailAction>(_deleteMoodDetail),
  TypedReducer<AppState, DeleteMoodDetailSuccessAction>(
      _deleteMoodDetailSuccess),
  TypedReducer<AppState, DeleteMoodDetailFailureAction>(_deleteMoodDetailError),
];
