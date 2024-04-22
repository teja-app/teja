import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/core_actions.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

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
class AddImageToQuestionAnswerPair {
  final String journalEntryId;
  final String questionAnswerPairId;
  final ImageEntry imageEntry;

  const AddImageToQuestionAnswerPair({
    required this.journalEntryId,
    required this.questionAnswerPairId,
    required this.imageEntry,
  });
}

@immutable
class RemoveImageFromQuestionAnswerPair {
  final String journalEntryId;
  final String questionAnswerPairId;
  final String imageId;

  const RemoveImageFromQuestionAnswerPair({
    required this.journalEntryId,
    required this.questionAnswerPairId,
    required this.imageId,
  });
}

@immutable
class AddOrUpdateImageAction {
  final String journalEntryId;
  final ImageEntry imageEntry;

  const AddOrUpdateImageAction({
    required this.journalEntryId,
    required this.imageEntry,
  });
}

@immutable
class AddOrUpdateImageSuccessAction {
  const AddOrUpdateImageSuccessAction();
}

@immutable
class AddOrUpdateImageFailureAction {
  final String error;

  const AddOrUpdateImageFailureAction(this.error);
}

@immutable
class RemoveImageAction {
  final String journalEntryId;
  final String imageHash;

  const RemoveImageAction({
    required this.journalEntryId,
    required this.imageHash,
  });
}

@immutable
class RemoveImageSuccessAction {
  const RemoveImageSuccessAction();
}

@immutable
class RemoveImageFailureAction {
  final String error;

  const RemoveImageFailureAction(this.error);
}

@immutable
class AddImageToQuestionAnswerPairSuccessAction {
  const AddImageToQuestionAnswerPairSuccessAction();
}

@immutable
class AddImageToQuestionAnswerPairFailureAction {
  final String error;

  const AddImageToQuestionAnswerPairFailureAction(this.error);
}

@immutable
class RemoveImageFromQuestionAnswerPairSuccessAction {
  const RemoveImageFromQuestionAnswerPairSuccessAction();
}

@immutable
class RemoveImageFromQuestionAnswerPairFailureAction {
  final String error;

  const RemoveImageFromQuestionAnswerPairFailureAction(this.error);
}

@immutable
class RefreshImagesAction {
  final String journalEntryId;

  const RefreshImagesAction(this.journalEntryId);
}

@immutable
class UpdateJournalEntryWithImages {
  final JournalEntryEntity journalEntry;

  const UpdateJournalEntryWithImages(this.journalEntry);
}
