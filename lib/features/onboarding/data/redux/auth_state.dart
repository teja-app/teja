import 'package:flutter/material.dart';

@immutable
class AuthState {
  final String registerMessage;
  final String googleClientIdIos;
  final String googleServerClientId;

  AuthState({
    required this.registerMessage,
    required this.googleClientIdIos,
    required this.googleServerClientId,
  });

  AuthState copyWith({
    String? registerMessage,
    String? googleClientIdIos,
    String? googleServerClientId,
  }) {
    return AuthState(
      registerMessage: registerMessage ?? this.registerMessage,
      googleClientIdIos: googleClientIdIos ?? this.googleClientIdIos,
      googleServerClientId: googleServerClientId ?? this.googleServerClientId,
    );
  }

  static AuthState initialState() {
    return AuthState(
      registerMessage: '',
      googleClientIdIos: '',
      googleServerClientId: '',
    );
  }
}
