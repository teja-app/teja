import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class JournalEditorState {
  final JournalEntryEntity? currentJournalEntry;
  final int currentPageIndex;
  final String? error;

  const JournalEditorState({
    this.currentJournalEntry,
    this.currentPageIndex = 0,
    this.error,
  });

  JournalEditorState copyWith({
    JournalEntryEntity? currentJournalEntry,
    int? currentPageIndex,
    String? error,
  }) {
    return JournalEditorState(
      currentJournalEntry: currentJournalEntry ?? this.currentJournalEntry,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      error: error ?? this.error,
    );
  }

  factory JournalEditorState.initialState() => const JournalEditorState();
}
