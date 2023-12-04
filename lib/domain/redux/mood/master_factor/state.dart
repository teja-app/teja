import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/master_factor.dart';

@immutable
class MasterFactorState {
  final List<MasterFactorEntity> masterFactors; // List to store master factors
  final bool isLoading; // Indicates if master factors are being loaded
  final String? errorMessage; // Holds error message, if any
  final DateTime? lastUpdatedAt;
  final bool isFetchSuccessful;

  const MasterFactorState({
    required this.masterFactors,
    this.isLoading = false,
    this.isFetchSuccessful = false,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  // Factory constructor for initial state
  factory MasterFactorState.initial() {
    return const MasterFactorState(
      masterFactors: [], // Initial empty list
      isLoading: false, // Not loading initially
      errorMessage: null, // No error initially
    );
  }

  // CopyWith method to copy the state with optional new values
  MasterFactorState copyWith({
    List<MasterFactorEntity>? masterFactors,
    bool? isLoading,
    String? errorMessage,
    bool? isFetchSuccessful,
    DateTime? lastUpdatedAt,
  }) {
    return MasterFactorState(
      masterFactors: masterFactors ?? this.masterFactors,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetchSuccessful: isFetchSuccessful ?? this.isFetchSuccessful,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return 'MasterFactorState(masterFactors: $masterFactors, isLoading: $isLoading, errorMessage: $errorMessage, lastUpdatedAt: $lastUpdatedAt, isFetchSuccessful: $isFetchSuccessful)';
  }
}
