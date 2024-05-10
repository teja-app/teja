import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

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
