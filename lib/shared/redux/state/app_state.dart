import 'package:flutter/material.dart';
import 'package:swayam/features/onboarding/data/redux/auth_state.dart';

@immutable
class AppState {
  final AuthState authState; // Nested AuthState

  AppState({
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
