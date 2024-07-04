import 'package:flutter/foundation.dart';

@immutable
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthSuccessful;
  final String? mnemonic;
  final int? blankIndex; 


  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthSuccessful = false,
    this.mnemonic,
    this.blankIndex,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      errorMessage: null,
      isAuthSuccessful: false,
      mnemonic: null,
      blankIndex: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthSuccessful,
    String? mnemonic,
    int? blankIndex,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthSuccessful: isAuthSuccessful ?? this.isAuthSuccessful,
      mnemonic: mnemonic ?? this.mnemonic,
      blankIndex: blankIndex ?? this.blankIndex,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, errorMessage: $errorMessage, isAuthSuccessful: $isAuthSuccessful, mnemonic: $mnemonic)';
  }
}
