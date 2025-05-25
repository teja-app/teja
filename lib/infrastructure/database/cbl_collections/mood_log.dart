import 'package:cbl/cbl.dart';

part 'mood_log.cbl.type.g.dart';

@TypedDictionary()
abstract class MoodLogAI with _$MoodLogAI {
  factory MoodLogAI({
    String? suggestion,
    String? title,
    String? affirmation,
  }) = MutableMoodLogAI;
}

@TypedDictionary()
abstract class MoodLogFeeling with _$MoodLogFeeling {
  factory MoodLogFeeling({
    String? feeling,
    String? comment,
    List<String>? factors,
    bool? detailed,
  }) = MutableMoodLogFeeling;
}

@TypedDictionary()
abstract class MoodLogAttachment with _$MoodLogAttachment {
  factory MoodLogAttachment({
    required String id,
    required String type,
    required String path,
  }) = MutableMoodLogAttachment;
}

@TypedDocument()
abstract class MoodLog with _$MoodLog {
  factory MoodLog({
    @DocumentId() String? id,
    required DateTime timestamp,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int moodRating,
    String? comment,
    String? senderId,
    MoodLogAI? ai,
    List<MoodLogFeeling>? feelings,
    List<String>? factors,
    List<MoodLogAttachment>? attachments,
    bool? isDeleted,
  }) = MutableMoodLog;
}