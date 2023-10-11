import 'package:flutter/foundation.dart';

enum PromiseStatus {
  Initial,
  Pending,
  Fulfilled,
  Rejected,
}

@immutable
class PromiseState {
  final PromiseStatus status;
  final String message;

  PromiseState({required this.status, required this.message});

  PromiseState copyWith({
    PromiseStatus? status,
    String? message,
  }) {
    return PromiseState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
