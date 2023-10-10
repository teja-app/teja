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

AppState signInSuccessReducer(AppState state, SignInSuccessAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      accessToken: action.accessToken,
      refreshToken: action.refreshToken,
    ),
  );
}

AppState signInFailureReducer(AppState state, SignInFailureAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      signInMessage: action.error,
    ),
  );
}

AppState clearSignInMessageReducer(
    AppState state, ClearSignInMessageAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      signInMessage: "",
    ),
  );
}

Reducer<AppState> appReducer = combineReducers<AppState>([
  TypedReducer<AppState, SetGoogleClientIdsAction>(googleAuthReducer),
  TypedReducer<AppState, RegisterSuccessAction>(registerSuccessReducer),
  TypedReducer<AppState, RegisterFailureAction>(registerFailureReducer),
  TypedReducer<AppState, ClearRegisterMessageAction>(
    clearRegisterMessageReducer,
  ),
  TypedReducer<AppState, SignInSuccessAction>(signInSuccessReducer),
  TypedReducer<AppState, SignInFailureAction>(signInFailureReducer),
  TypedReducer<AppState, ClearSignInMessageAction>(clearSignInMessageReducer),
]);

AppState googleAuthReducer(AppState state, SetGoogleClientIdsAction action) {
  return state.copyWith(
    authState: state.authState.copyWith(
      googleClientIdIos: action.googleClientIdIos,
      googleServerClientId: action.googleServerClientId,
    ),
  );
}
