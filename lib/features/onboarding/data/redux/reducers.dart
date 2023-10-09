import 'package:redux/redux.dart';
import 'package:swayam/features/onboarding/data/redux/actions.dart';
import 'package:swayam/shared/redux/state/app_state.dart';

AppState registerSuccessReducer(AppState state, RegisterSuccessAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      registerMessage: action.message,
    ),
  );
}

AppState registerFailureReducer(AppState state, RegisterFailureAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      registerMessage: action.error,
    ),
  );
}

AppState clearRegisterMessageReducer(
  AppState state,
  ClearRegisterMessageAction action,
) {
  return state.copyWith(
    authState: state.authState.copyWith(
      registerMessage: "",
    ),
  );
}

Reducer<AppState> appReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetGoogleClientIdsAction>(googleAuthReducer),
  TypedReducer<AppState, RegisterSuccessAction>(registerSuccessReducer),
  TypedReducer<AppState, RegisterFailureAction>(registerFailureReducer),
  TypedReducer<AppState, ClearRegisterMessageAction>(
      clearRegisterMessageReducer),
]);

AppState googleAuthReducer(AppState state, SetGoogleClientIdsAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      googleClientIdIos: action.googleClientIdIos,
      googleServerClientId: action.googleServerClientId,
    ),
  );
}
