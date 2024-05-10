import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

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
class AddVoiceToQuestionAnswerPairSuccessAction {
  const AddVoiceToQuestionAnswerPairSuccessAction();
}

@immutable
class AddVoiceToQuestionAnswerPairFailureAction {
  final String error;

  const AddVoiceToQuestionAnswerPairFailureAction(this.error);
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
