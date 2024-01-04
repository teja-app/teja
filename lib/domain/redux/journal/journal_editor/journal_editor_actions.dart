import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/core_actions.dart';

@immutable
class InitializeJournalEditor {
  final String journalEntryId;
  const InitializeJournalEditor(this.journalEntryId);
}

@immutable
class SaveJournalEntry {
  final JournalEntryEntity journalEntry;
  const SaveJournalEntry(this.journalEntry);
}

@immutable
class JournalEntrySaved extends SuccessAction {
  JournalEntrySaved(String message) : super(message);
}

@immutable
class JournalEntrySaveFailed extends FailureAction {
  JournalEntrySaveFailed(String error) : super(error);
}

@immutable
class UpdateQuestionAnswerSuccessAction {
  final String journalEntryId;
  final String questionId;
  final String answerText;

  const UpdateQuestionAnswerSuccessAction({
    required this.journalEntryId,
    required this.questionId,
    required this.answerText,
  });
}

@immutable
class UpdateQuestionAnswerFailureAction {
  final String error;

  const UpdateQuestionAnswerFailureAction(this.error);
}

@immutable
class UpdateQuestionAnswer {
  final String journalEntryId;
  final String questionId;
  final String answerText;
  const UpdateQuestionAnswer({
    required this.journalEntryId,
    required this.questionId,
    required this.answerText,
  });
}

@immutable
class QuestionAnswerUpdated extends SuccessAction {
  QuestionAnswerUpdated(String message) : super(message);
}

@immutable
class QuestionAnswerUpdateFailed extends FailureAction {
  QuestionAnswerUpdateFailed(String error) : super(error);
}

@immutable
class ClearJournalEditor {
  const ClearJournalEditor();
}

@immutable
class InitializeJournalEditorSuccessAction {
  final JournalEntryEntity journalEntry;

  const InitializeJournalEditorSuccessAction(this.journalEntry);
}

@immutable
class InitializeJournalEditorFailureAction {
  final String error;

  const InitializeJournalEditorFailureAction(this.error);
}
