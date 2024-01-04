import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class JournalEditorState {
  final JournalEntryEntity? currentJournalEntry;
  final String? error;

  const JournalEditorState({
    this.currentJournalEntry,
    this.error,
  });

  JournalEditorState copyWith({
    JournalEntryEntity? currentJournalEntry,
    String? error,
  }) {
    return JournalEditorState(
      currentJournalEntry: currentJournalEntry ?? this.currentJournalEntry,
      error: error ?? this.error,
    );
  }

  factory JournalEditorState.initialState() => const JournalEditorState();
}
