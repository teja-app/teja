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
  final bool isKeyboardVisible;
  final double keyboardHeight;
  final bool hasFocus;

  const JournalEditorState({
    this.currentJournalEntry,
    this.currentPageIndex = 0,
    this.error,
    this.autoSaveStatus = AutoSaveStatus.idle,
    this.autoSaveError,
    this.isKeyboardVisible = false,
    this.keyboardHeight = 0.0,
    this.hasFocus = false,
  });

  JournalEditorState copyWith({
    JournalEntryEntity? currentJournalEntry,
    int? currentPageIndex,
    String? error,
    AutoSaveStatus? autoSaveStatus,
    String? autoSaveError,
    bool? isKeyboardVisible,
    double? keyboardHeight,
    bool? hasFocus,
  }) {
    return JournalEditorState(
      currentJournalEntry: currentJournalEntry ?? this.currentJournalEntry,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      error: error ?? this.error,
      autoSaveStatus: autoSaveStatus ?? this.autoSaveStatus,
      autoSaveError: autoSaveError ?? this.autoSaveError,
      isKeyboardVisible: isKeyboardVisible ?? this.isKeyboardVisible,
      keyboardHeight: keyboardHeight ?? this.keyboardHeight,
      hasFocus: hasFocus ?? this.hasFocus,
    );
  }

  factory JournalEditorState.initialState() => const JournalEditorState();
}
