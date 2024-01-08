import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

@immutable
class JournalLogsState {
  final Map<String, List<JournalEntryEntity>> journalLogsByDate;
  final bool isFetching;
  final String? errorMessage;
  final bool fetchSuccess;

  const JournalLogsState({
    this.journalLogsByDate = const {},
    this.isFetching = false,
    this.errorMessage,
    this.fetchSuccess = false,
  });

  JournalLogsState copyWith({
    Map<String, List<JournalEntryEntity>>? journalLogsByDate,
    bool? isFetching,
    String? errorMessage,
    bool? fetchSuccess,
  }) {
    return JournalLogsState(
      journalLogsByDate: journalLogsByDate ?? this.journalLogsByDate,
      isFetching: isFetching ?? this.isFetching,
      errorMessage: errorMessage ?? this.errorMessage,
      fetchSuccess: fetchSuccess ?? this.fetchSuccess,
    );
  }

  factory JournalLogsState.initialState() => const JournalLogsState();
}
