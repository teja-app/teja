import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

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
class AddVideoToQuestionAnswerPairSuccessAction {
  const AddVideoToQuestionAnswerPairSuccessAction();
}

@immutable
class AddVideoToQuestionAnswerPairFailureAction {
  final String error;

  const AddVideoToQuestionAnswerPairFailureAction(this.error);
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
