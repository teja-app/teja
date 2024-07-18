import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/app_error/app_error_state.dart';

AppErrorState appErrorReducer(AppErrorState state, dynamic action) {
  return combineReducers<AppErrorState>([
    TypedReducer<AppErrorState, AddAppErrorAction>(_addAppError),
    TypedReducer<AppErrorState, ClearExpiredErrorsAction>(_clearExpiredErrors),
    TypedReducer<AppErrorState, ClearAllErrorsAction>(_clearAllErrors),
    TypedReducer<AppErrorState, ClearErrorAction>(_clearError),
  ])(state, action);
}

AppErrorState _addAppError(AppErrorState state, AddAppErrorAction action) {
  final now = DateTime.now();
  final validErrors = state.errors.where((error) {
    return now.difference(error.timestamp) <= state.aggregationWindow && error.code != action.error.code;
  }).toList();
  return state.copyWith(errors: [...validErrors, action.error]);
}

AppErrorState _clearExpiredErrors(AppErrorState state, ClearExpiredErrorsAction action) {
  final now = DateTime.now();
  final validErrors = state.errors.where((error) {
    return now.difference(error.timestamp) <= state.aggregationWindow;
  }).toList();
  return state.copyWith(errors: validErrors);
}

AppErrorState _clearAllErrors(AppErrorState state, ClearAllErrorsAction action) {
  return state.copyWith(errors: []);
}

AppErrorState _clearError(AppErrorState state, ClearErrorAction action) {
  final updatedErrors = state.errors.where((error) => error != action.error).toList();
  return state.copyWith(errors: updatedErrors);
}
