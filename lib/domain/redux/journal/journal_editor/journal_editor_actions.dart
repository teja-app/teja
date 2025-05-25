import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/core_actions.dart';

@immutable
class InitializeJournalEditor {
  final String? journalEntryId;
  final DateTime? timestamp;

  const InitializeJournalEditor(
      {this.journalEntryId, this.timestamp});
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

@immutable
class AddUrlMetadataToJournalEntry {
  final String journalEntryId;
  final String url;
  final String title;
  final String description;
  final String image;
  final String logo;
  final String body;

  const AddUrlMetadataToJournalEntry({
    required this.journalEntryId,
    required this.url,
    required this.title,
    required this.description,
    required this.image,
    required this.logo,
    required this.body,
  });
}

@immutable
class AddUrlMetadataToJournalEntrySuccess {
  const AddUrlMetadataToJournalEntrySuccess();
}

@immutable
class AddUrlMetadataToJournalEntryFailure {
  final String error;

  const AddUrlMetadataToJournalEntryFailure(this.error);
}

@immutable
class RemoveUrlMetadataFromJournalEntry {
  final String journalEntryId;
  final String url;

  const RemoveUrlMetadataFromJournalEntry({
    required this.journalEntryId,
    required this.url,
  });
}

@immutable
class RemoveUrlMetadataFromJournalEntrySuccess {
  const RemoveUrlMetadataFromJournalEntrySuccess();
}

@immutable
class RemoveUrlMetadataFromJournalEntryFailure {
  final String error;

  const RemoveUrlMetadataFromJournalEntryFailure(this.error);
}
