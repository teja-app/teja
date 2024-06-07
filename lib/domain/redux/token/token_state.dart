import 'package:flutter/foundation.dart';

@immutable
class TokenState {
  final int total;
  final int used;
  final int pending;
  final int usedToday;
  final String? errorMessage;

  const TokenState({
    this.total = 0,
    this.used = 0,
    this.pending = 0,
    this.usedToday = 0,
    this.errorMessage,
  });

  factory TokenState.initial() {
    return const TokenState(
      total: 0,
      used: 0,
      pending: 0,
      usedToday: 0,
      errorMessage: null,
    );
  }

  TokenState copyWith({
    int? total,
    int? used,
    int? pending,
    int? usedToday,
    String? errorMessage,
  }) {
    return TokenState(
      total: total ?? this.total,
      used: used ?? this.used,
      pending: pending ?? this.pending,
      usedToday: usedToday ?? this.usedToday,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'TokenState(total: $total, used: $used, pending: $pending, usedToday: $usedToday, errorMessage: $errorMessage)';
  }
}
