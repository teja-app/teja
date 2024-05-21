import 'package:flutter/material.dart';

@immutable
class RegisterAction {
  final String userId;
  final String mnemonic;

  const RegisterAction(this.userId, this.mnemonic);
}

@immutable
class RegisterSuccessAction {}

@immutable
class RegisterFailedAction {
  final String error;

  const RegisterFailedAction(this.error);
}

@immutable
class AuthenticateAction {
  final String userId;
  final String mnemonic;

  const AuthenticateAction(this.userId, this.mnemonic);
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
