import 'package:flutter/material.dart';

@immutable
class TokenReceivedAction {
  final String accessToken;
  final String refreshToken;

  const TokenReceivedAction(this.accessToken, this.refreshToken);
}

@immutable
class RefreshTokenAction {
  final String refreshToken;

  const RefreshTokenAction(this.refreshToken);
}

@immutable
class RefreshTokenSuccessAction {
  final String accessToken;

  const RefreshTokenSuccessAction(this.accessToken);
}

@immutable
class RefreshTokenFailedAction {
  final String error;

  const RefreshTokenFailedAction(this.error);
}

@immutable
class RegisterAction {
  final String mnemonic;

  const RegisterAction(this.mnemonic);
}

@immutable
class RegisterSuccessAction {
  final String mnemonic; // Add this

  const RegisterSuccessAction(this.mnemonic); // Update constructor
}

@immutable
class RegisterFailedAction {
  final String error;

  const RegisterFailedAction(this.error);
}

@immutable
class AuthenticateAction {
  final String mnemonic;

  const AuthenticateAction(this.mnemonic);
}

@immutable
class AuthenticateSuccessAction {}

@immutable
class AuthenticateFailedAction {
  final String error;

  const AuthenticateFailedAction(this.error);
}

@immutable
class AuthInProgressAction {}

@immutable
class FetchRecoveryPhraseAction {}

@immutable
class FetchRecoveryPhraseSuccessAction {
  final String mnemonic;

  const FetchRecoveryPhraseSuccessAction(this.mnemonic);
}

@immutable
class FetchRecoveryPhraseFailedAction {
  final String error;

  const FetchRecoveryPhraseFailedAction(this.error);
}
