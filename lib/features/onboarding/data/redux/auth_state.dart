import 'package:flutter/material.dart';

@immutable
class AuthState {
  final String registerMessage;
  final String signInMessage;
  final String googleClientIdIos;
  final int? accessTokenExpiry;
  final String googleServerClientId;

  const AuthState({
    required this.registerMessage,
    required this.signInMessage,
    this.accessTokenExpiry,
    required this.googleClientIdIos,
    required this.googleServerClientId,
  });

  AuthState copyWith({
    String? registerMessage,
    String? signInMessage,
    int? accessTokenExpiry,
    String? googleClientIdIos,
    String? googleServerClientId,
  }) {
    return AuthState(
      registerMessage: registerMessage ?? this.registerMessage,
      signInMessage: signInMessage ?? this.signInMessage,
      googleClientIdIos: googleClientIdIos ?? this.googleClientIdIos,
      accessTokenExpiry: accessTokenExpiry ?? this.accessTokenExpiry,
      googleServerClientId: googleServerClientId ?? this.googleServerClientId,
    );
  }

  static AuthState initialState() {
    return const AuthState(
      registerMessage: '',
      signInMessage: '',
      googleClientIdIos: '',
      googleServerClientId: '',
    );
  }
}
