import 'package:flutter/foundation.dart';

@immutable
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthSuccessful;
  final String? mnemonic;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthSuccessful = false,
    this.mnemonic,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      errorMessage: null,
      isAuthSuccessful: false,
      mnemonic: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthSuccessful,
    String? mnemonic,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthSuccessful: isAuthSuccessful ?? this.isAuthSuccessful,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, errorMessage: $errorMessage, isAuthSuccessful: $isAuthSuccessful, mnemonic: $mnemonic)';
  }
}
