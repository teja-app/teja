import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/habit/habit/habit_state.dart';

final Reducer<HabitState> habitReducer = combineReducers<HabitState>([
  TypedReducer<HabitState, FetchHabitsAction>(_fetchHabits),
  TypedReducer<HabitState, FetchHabitsSuccessAction>(_fetchHabitsSuccess),
  TypedReducer<HabitState, FetchHabitsErrorAction>(_fetchHabitsError),
  // ... add other TypedReducers for different actions as needed
]);

HabitState _fetchHabits(HabitState state, FetchHabitsAction action) {
  return state.copyWith(isLoading: true);
}

HabitState _fetchHabitsSuccess(
    HabitState state, FetchHabitsSuccessAction action) {
  return state.copyWith(
    habits: action.habits,
    isLoading: false,
    error: null,
  );
}

HabitState _fetchHabitsError(HabitState state, FetchHabitsErrorAction action) {
  return state.copyWith(
    isLoading: false,
    error: action.error,
  );
}
