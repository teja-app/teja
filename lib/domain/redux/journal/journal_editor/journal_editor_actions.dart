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

// ...

@immutable
class AddOrUpdateVideoAction {
  final String journalEntryId;
  final VideoEntry videoEntry;

  const AddOrUpdateVideoAction({
    required this.journalEntryId,
    required this.videoEntry,
  });
}

@immutable
class AddOrUpdateVideoSuccessAction {
  const AddOrUpdateVideoSuccessAction();
}

@immutable
class AddOrUpdateVideoFailureAction {
  final String error;

  const AddOrUpdateVideoFailureAction(this.error);
}

@immutable
class RemoveVideoAction {
  final String journalEntryId;
  final String videoHash;

  const RemoveVideoAction({
    required this.journalEntryId,
    required this.videoHash,
  });
}

@immutable
class RemoveVideoSuccessAction {
  const RemoveVideoSuccessAction();
}

@immutable
class RemoveVideoFailureAction {
  final String error;

  const RemoveVideoFailureAction(this.error);
}

@immutable
class AddVideoToQuestionAnswerPair {
  final String journalEntryId;
  final String questionAnswerPairId;
  final VideoEntry videoEntry;

  const AddVideoToQuestionAnswerPair({
    required this.journalEntryId,
    required this.questionAnswerPairId,
    required this.videoEntry,
  });
}

@immutable
class AddVideoToQuestionAnswerPairSuccessAction {
  const AddVideoToQuestionAnswerPairSuccessAction();
}

@immutable
class AddVideoToQuestionAnswerPairFailureAction {
  final String error;

  const AddVideoToQuestionAnswerPairFailureAction(this.error);
}

@immutable
class RemoveVideoFromQuestionAnswerPair {
  final String journalEntryId;
  final String questionAnswerPairId;
  final String videoId;

  const RemoveVideoFromQuestionAnswerPair({
    required this.journalEntryId,
    required this.questionAnswerPairId,
    required this.videoId,
  });
}

@immutable
class RemoveVideoFromQuestionAnswerPairSuccessAction {
  const RemoveVideoFromQuestionAnswerPairSuccessAction();
}

@immutable
class RemoveVideoFromQuestionAnswerPairFailureAction {
  final String error;

  const RemoveVideoFromQuestionAnswerPairFailureAction(this.error);
}

@immutable
class RefreshVideosAction {
  final String journalEntryId;

  const RefreshVideosAction(this.journalEntryId);
}

@immutable
class UpdateJournalEntryWithVideos {
  final JournalEntryEntity journalEntry;

  const UpdateJournalEntryWithVideos(this.journalEntry);
}

@immutable
class AddOrUpdateVoiceAction {
  final String journalEntryId;
  final VoiceEntry voiceEntry;

  const AddOrUpdateVoiceAction({
    required this.journalEntryId,
    required this.voiceEntry,
  });
}

@immutable
class AddOrUpdateVoiceSuccessAction {
  const AddOrUpdateVoiceSuccessAction();
}

@immutable
class AddOrUpdateVoiceFailureAction {
  final String error;

  const AddOrUpdateVoiceFailureAction(this.error);
}

@immutable
class RemoveVoiceAction {
  final String journalEntryId;
  final String voiceHash;

  const RemoveVoiceAction({
    required this.journalEntryId,
    required this.voiceHash,
  });
}

@immutable
class RemoveVoiceSuccessAction {
  const RemoveVoiceSuccessAction();
}

@immutable
class RemoveVoiceFailureAction {
  final String error;

  const RemoveVoiceFailureAction(this.error);
}

@immutable
class AddVoiceToQuestionAnswerPair {
  final String journalEntryId;
  final String questionAnswerPairId;
  final VoiceEntry voiceEntry;

  const AddVoiceToQuestionAnswerPair({
    required this.journalEntryId,
    required this.questionAnswerPairId,
    required this.voiceEntry,
  });
}

@immutable
class AddVoiceToQuestionAnswerPairSuccessAction {
  const AddVoiceToQuestionAnswerPairSuccessAction();
}

@immutable
class AddVoiceToQuestionAnswerPairFailureAction {
  final String error;

  const AddVoiceToQuestionAnswerPairFailureAction(this.error);
}

@immutable
class RemoveVoiceFromQuestionAnswerPair {
  final String journalEntryId;
  final String questionAnswerPairId;
  final String voiceId;

  const RemoveVoiceFromQuestionAnswerPair({
    required this.journalEntryId,
    required this.questionAnswerPairId,
    required this.voiceId,
  });
}

@immutable
class RemoveVoiceFromQuestionAnswerPairSuccessAction {
  const RemoveVoiceFromQuestionAnswerPairSuccessAction();
}

@immutable
class RemoveVoiceFromQuestionAnswerPairFailureAction {
  final String error;

  const RemoveVoiceFromQuestionAnswerPairFailureAction(this.error);
}

@immutable
class RefreshVoicesAction {
  final String journalEntryId;

  const RefreshVoicesAction(this.journalEntryId);
}

@immutable
class UpdateJournalEntryWithVoices {
  final JournalEntryEntity journalEntry;

  const UpdateJournalEntryWithVoices(this.journalEntry);
}
