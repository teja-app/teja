import 'package:flutter/foundation.dart';

@immutable
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthSuccessful;
  final String? mnemonic;
  final int? blankIndex;
  final bool hasExistingMnemonic;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthSuccessful = false,
    this.mnemonic,
    this.blankIndex,
    this.hasExistingMnemonic = true,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      errorMessage: null,
      isAuthSuccessful: false,
      mnemonic: null,
      blankIndex: null,
      hasExistingMnemonic: true,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthSuccessful,
    String? mnemonic,
    int? blankIndex,
    bool? hasExistingMnemonic,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthSuccessful: isAuthSuccessful ?? this.isAuthSuccessful,
      mnemonic: mnemonic ?? this.mnemonic,
      blankIndex: blankIndex ?? this.blankIndex,
      hasExistingMnemonic: hasExistingMnemonic ?? this.hasExistingMnemonic,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, errorMessage: $errorMessage, isAuthSuccessful: $isAuthSuccessful, mnemonic: $mnemonic)';
  }
}
