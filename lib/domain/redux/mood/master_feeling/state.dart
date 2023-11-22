// lib/domain/redux/mood/master_feeling/state.dart

import 'package:flutter/foundation.dart';
import 'package:swayam/domain/entities/master_feeling.dart';

@immutable
class MasterFeelingState {
  final List<MasterFeelingEntity>
      masterFeelings; // List to store master feelings
  final bool isLoading; // Indicates if master feelings are being loaded
  final String? errorMessage; // Holds error message, if any
  final DateTime? lastUpdatedAt;
  final bool isFetchSuccessful;

  const MasterFeelingState({
    required this.masterFeelings,
    this.isLoading = false,
    this.isFetchSuccessful = false,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  // Factory constructor for initial state
  factory MasterFeelingState.initial() {
    return const MasterFeelingState(
      masterFeelings: [], // Initial empty list
      isLoading: false, // Not loading initially
      errorMessage: null, // No error initially
    );
  }

  // CopyWith method to copy the state with optional new values
  MasterFeelingState copyWith({
    List<MasterFeelingEntity>? masterFeelings,
    bool? isLoading,
    String? errorMessage,
    bool? isFetchSuccessful,
    DateTime? lastUpdatedAt,
  }) {
    return MasterFeelingState(
      masterFeelings: masterFeelings ?? this.masterFeelings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetchSuccessful: isFetchSuccessful ?? this.isFetchSuccessful,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return 'MasterFeelingState(masterFeelings: $masterFeelings, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
