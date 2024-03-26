import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class JournalListState {
  final bool isLoading;
  final List<JournalEntryEntity> journalEntries;
  final String? errorMessage;
  final bool isLastPage;

  const JournalListState({
    this.isLoading = false,
    this.journalEntries = const [],
    this.errorMessage,
    this.isLastPage = false,
  });

  factory JournalListState.initial() {
    return const JournalListState();
  }

  JournalListState copyWith({
    bool? isLoading,
    List<JournalEntryEntity>? journalEntries,
    String? errorMessage,
    bool? isLastPage,
  }) {
    return JournalListState(
      isLoading: isLoading ?? this.isLoading,
      journalEntries: journalEntries ?? this.journalEntries,
      errorMessage: errorMessage ?? this.errorMessage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}
