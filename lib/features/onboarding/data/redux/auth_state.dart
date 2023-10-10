import 'package:flutter/material.dart';

@immutable
class AuthState {
  final String registerMessage;
  final String signInMessage;
  final String accessToken;
  final String refreshToken;
  final String googleClientIdIos;
  final String googleServerClientId;

  AuthState({
    required this.registerMessage,
    required this.signInMessage,
    required this.accessToken,
    required this.refreshToken,
    required this.googleClientIdIos,
    required this.googleServerClientId,
  });

  AuthState copyWith({
    String? registerMessage,
    String? signInMessage,
    String? accessToken,
    String? refreshToken,
    String? googleClientIdIos,
    String? googleServerClientId,
  }) {
    return AuthState(
      registerMessage: registerMessage ?? this.registerMessage,
      signInMessage: signInMessage ?? this.signInMessage,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      googleClientIdIos: googleClientIdIos ?? this.googleClientIdIos,
      googleServerClientId: googleServerClientId ?? this.googleServerClientId,
    );
  }

  static AuthState initialState() {
    return AuthState(
      registerMessage: '',
      signInMessage: '',
      accessToken: '',
      refreshToken: '',
      googleClientIdIos: '',
      googleServerClientId: '',
    );
  }
}
