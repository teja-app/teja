// lib/domain/redux/journal/detail/journal_detail_state.dart
import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class JournalDetailState {
  final JournalEntryEntity? selectedJournalEntry;
  final bool isLoading;
  final String? errorMessage;

  const JournalDetailState({
    this.selectedJournalEntry,
    this.isLoading = false,
    this.errorMessage,
  });

  JournalDetailState copyWith({
    JournalEntryEntity? selectedJournalEntry,
    bool? isLoading,
    String? errorMessage,
  }) {
    return JournalDetailState(
      selectedJournalEntry: selectedJournalEntry ?? this.selectedJournalEntry,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory JournalDetailState.initialState() => const JournalDetailState();
}
