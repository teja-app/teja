import 'package:flutter/material.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';

@immutable
class AppState {
  final AuthState authState; // Nested AuthState

  const AppState({
    required this.authState,
  });

  AppState copyWith({
    AuthState? authState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
    );
  }

  static AppState initialState() {
    return AppState(
      authState: AuthState.initialState(),
    );
  }
}
