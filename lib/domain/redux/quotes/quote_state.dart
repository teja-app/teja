import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/quote_entity.dart';

@immutable
class QuoteState {
  final List<QuoteEntity> quotes;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;
  final bool isFetchSuccessful;

  const QuoteState({
    required this.quotes,
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdatedAt,
    this.isFetchSuccessful = false,
  });

  factory QuoteState.initial() {
    return const QuoteState(
      quotes: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  QuoteState copyWith({
    List<QuoteEntity>? quotes,
    bool? isLoading,
    String? errorMessage,
    bool? isFetchSuccessful,
    DateTime? lastUpdatedAt,
  }) {
    return QuoteState(
      quotes: quotes ?? this.quotes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetchSuccessful: isFetchSuccessful ?? this.isFetchSuccessful,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return 'QuoteState(quotes: $quotes, isLoading: $isLoading, errorMessage: $errorMessage, lastUpdatedAt: $lastUpdatedAt, isFetchSuccessful: $isFetchSuccessful)';
  }
}
