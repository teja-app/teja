import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/app_error.dart';

@immutable
class AppErrorState {
  final List<AppError> errors;
  final Duration aggregationWindow;

  const AppErrorState({
    required this.errors,
    this.aggregationWindow = const Duration(seconds: 2),
  });

  factory AppErrorState.initial() {
    return AppErrorState(errors: []);
  }

  AppErrorState copyWith({
    List<AppError>? errors,
    Duration? aggregationWindow,
  }) {
    return AppErrorState(
      errors: errors ?? this.errors,
      aggregationWindow: aggregationWindow ?? this.aggregationWindow,
    );
  }
}
