import 'package:cbl/cbl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_entry.cbl.type.g.dart';

@TypedDictionary()
abstract class QuestionAnswerPair with _$QuestionAnswerPair {
  factory QuestionAnswerPair({
    required String id,
    String? questionId,
    String? questionText,
    String? answerText,
    List<String>? imageEntryIds,
    List<String>? videoEntryIds,
    List<String>? voiceEntryIds,
  }) = MutableQuestionAnswerPair;
}

@TypedDictionary()
abstract class TextEntry with _$TextEntry {
  factory TextEntry({
    required String id,
    String? content,
  }) = MutableTextEntry;
}

@TypedDictionary()
abstract class ImageEntry with _$ImageEntry {
  factory ImageEntry({
    required String id,
    String? filePath,
    String? caption,
    String? hash,
  }) = MutableImageEntry;
}

@TypedDictionary()
abstract class UrlMetadata with _$UrlMetadata {
  factory UrlMetadata({
    required String id,
    String? url,
    String? title,
    String? description,
    String? image,
    String? logo,
    String? body,
  }) = MutableUrlMetadata;
}

@TypedDictionary()
abstract class VideoEntry with _$VideoEntry {
  factory VideoEntry({
    required String id,
    String? filePath,
    int? duration,
    String? hash,
  }) = MutableVideoEntry;
}

@TypedDictionary()
abstract class VoiceEntry with _$VoiceEntry {
  factory VoiceEntry({
    required String id,
    String? filePath,
    int? duration,
    String? hash,
  }) = MutableVoiceEntry;
}

@TypedDictionary()
abstract class BulletPointEntry with _$BulletPointEntry {
  factory BulletPointEntry({
    required String id,
    List<String>? points,
  }) = MutableBulletPointEntry;
}

@TypedDictionary()
abstract class PainNoteEntry with _$PainNoteEntry {
  factory PainNoteEntry({
    required String id,
    int? painLevel,
    String? notes,
  }) = MutablePainNoteEntry;
}

@TypedDictionary()
abstract class JournalEntryMetadata with _$JournalEntryMetadata {
  factory JournalEntryMetadata({
    List<String>? tags,
  }) = MutableJournalEntryMetadata;
}

@TypedDictionary()
abstract class JournalFeeling with _$JournalFeeling {
  factory JournalFeeling({
    String? emoticon,
    String? title,
  }) = MutableJournalFeeling;
}

@TypedDocument()
abstract class JournalEntry with _$JournalEntry {
  factory JournalEntry({
    @DocumentId() String? id,
    String? templateId,
    required DateTime timestamp,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<QuestionAnswerPair>? questions,
    List<TextEntry>? textEntries,
    List<VoiceEntry>? voiceEntries,
    List<VideoEntry>? videoEntries,
    List<ImageEntry>? imageEntries,
    List<BulletPointEntry>? bulletPointEntries,
    List<PainNoteEntry>? painNoteEntries,
    List<UrlMetadata>? urlMetadata,
    JournalEntryMetadata? metadata,
    bool? lock,
    String? emoticon,
    String? title,
    String? body,
    String? summary,
    String? keyInsight,
    String? affirmation,
    List<String>? topics,
    List<JournalFeeling>? feelings,
    required bool isDeleted,
  }) = MutableJournalEntry;
}
