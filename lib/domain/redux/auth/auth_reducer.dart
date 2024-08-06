import 'package:redux/redux.dart';
import 'package:teja/domain/redux/auth/auth_action.dart';
import 'package:teja/domain/redux/auth/auth_state.dart';

Reducer<AuthState> authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, AuthInProgressAction>(_authInProgress),
  TypedReducer<AuthState, RegisterSuccessAction>(_registerSuccess),
  TypedReducer<AuthState, RegisterFailedAction>(_registerFailed),
  TypedReducer<AuthState, AuthenticateSuccessAction>(_authenticateSuccess),
  TypedReducer<AuthState, AuthenticateFailedAction>(_authenticateFailed),
  TypedReducer<AuthState, FetchRecoveryPhraseSuccessAction>(_fetchRecoveryPhraseSuccess),
  TypedReducer<AuthState, FetchRecoveryPhraseFailedAction>(_fetchRecoveryPhraseFailed),
  TypedReducer<AuthState, SetBlankIndexAction>(_setBlankIndex),
  TypedReducer<AuthState, SetHasExistingMnemonicAction>(_setHasExistingMnemonic),
  TypedReducer<AuthState, ResetAuthStateAction>(_resetAuthState),
]);

AuthState _authInProgress(AuthState state, AuthInProgressAction action) {
  return state.copyWith(isLoading: true, errorMessage: null);
}

AuthState _registerSuccess(AuthState state, RegisterSuccessAction action) {
  return state.copyWith(isLoading: false, isAuthSuccessful: true, errorMessage: null);
}

AuthState _registerFailed(AuthState state, RegisterFailedAction action) {
  return state.copyWith(isLoading: false, isAuthSuccessful: false, errorMessage: action.error);
}

AuthState _authenticateSuccess(AuthState state, AuthenticateSuccessAction action) {
  return state.copyWith(isLoading: false, isAuthSuccessful: true, errorMessage: null);
}

AuthState _authenticateFailed(AuthState state, AuthenticateFailedAction action) {
  return state.copyWith(isLoading: false, isAuthSuccessful: false, errorMessage: action.error);
}

AuthState _fetchRecoveryPhraseSuccess(AuthState state, FetchRecoveryPhraseSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: null,
    mnemonic: action.mnemonic,
  );
}

AuthState _fetchRecoveryPhraseFailed(AuthState state, FetchRecoveryPhraseFailedAction action) {
  return state.copyWith(isLoading: false, errorMessage: action.error);
}

AuthState _setBlankIndex(AuthState state, SetBlankIndexAction action) {
  return state.copyWith(blankIndex: action.blankIndex);
}

AuthState _setHasExistingMnemonic(AuthState state, SetHasExistingMnemonicAction action) {
  return state.copyWith(hasExistingMnemonic: action.hasExistingMnemonic);
}

AuthState _resetAuthState(AuthState state, ResetAuthStateAction action) {
  return state.copyWith(
    isAuthSuccessful: false,
    errorMessage: null,
    isLoading: false,
  );
}

// Add this to your combineReducers list