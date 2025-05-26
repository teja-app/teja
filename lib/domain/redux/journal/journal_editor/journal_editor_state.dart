import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';

@immutable
class JournalEditorState {
  final JournalEntryEntity? currentJournalEntry;
  final int currentPageIndex;
  final String? error;
  final AutoSaveStatus autoSaveStatus;
  final String? autoSaveError;

  const JournalEditorState({
    this.currentJournalEntry,
    this.currentPageIndex = 0,
    this.error,
    this.autoSaveStatus = AutoSaveStatus.idle,
    this.autoSaveError,
  });

  JournalEditorState copyWith({
    JournalEntryEntity? currentJournalEntry,
    int? currentPageIndex,
    String? error,
    AutoSaveStatus? autoSaveStatus,
    String? autoSaveError,
  }) {
    return JournalEditorState(
      currentJournalEntry: currentJournalEntry ?? this.currentJournalEntry,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      error: error ?? this.error,
      autoSaveStatus: autoSaveStatus ?? this.autoSaveStatus,
      autoSaveError: autoSaveError ?? this.autoSaveError,
    );
  }

  factory JournalEditorState.initialState() => const JournalEditorState();
}
