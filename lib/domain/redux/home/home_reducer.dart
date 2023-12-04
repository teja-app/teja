// lib/domain/redux/home/home_reducer.dart

import 'package:teja/domain/redux/home/home_actions.dart';
import 'package:teja/domain/redux/home/home_state.dart';
import 'package:redux/redux.dart';

Reducer<HomeState> homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, UpdateSelectedDateAction>(_updateSelectedDate),
]);

HomeState _updateSelectedDate(HomeState state, UpdateSelectedDateAction action) {
  return state.copyWith(selectedDate: action.selectedDate);
}
