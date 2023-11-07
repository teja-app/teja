import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';

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
    moodDetailPage: state.moodDetailPage.copyWith(
      isLoading: false,
      errorMessage: action.errorMessage,
    ),
  );
}

final moodDetailReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, LoadMoodDetailAction>(_loadMoodDetail),
  TypedReducer<AppState, LoadMoodDetailSuccessAction>(_setMoodDetail),
  TypedReducer<AppState, LoadMoodDetailFailureAction>(_moodDetailError),
];
