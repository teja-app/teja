import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/core_actions.dart';

@immutable
class InitializeJournalEditor {
  final String? journalEntryId;
  final JournalTemplateEntity? template; // Make templateId optional
  final DateTime? timestamp;

  const InitializeJournalEditor({this.journalEntryId, this.template, this.timestamp});
}

@immutable
class ChangeJournalPageAction {
  final int pageIndex;

  const ChangeJournalPageAction(this.pageIndex);
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
  final String questionText;
  const UpdateQuestionAnswer({
    required this.journalEntryId,
    required this.questionId,
    required this.answerText,
    required this.questionText,
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
class ClearJournalEditorSuccess {
  const ClearJournalEditorSuccess();
}

@immutable
class ClearJournalEditorFailure {
  const ClearJournalEditorFailure();
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
