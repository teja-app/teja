import 'package:teja/domain/entities/feeling.dart';

class MoodLogAttachmentEntity {
  final String id;
  final String type;
  final String path;

  MoodLogAttachmentEntity({
    required this.id,
    required this.type,
    required this.path,
  });
}

class MoodLogAIEntity {
  final String? suggestion;
  final String? title; // Add this field
  final String? affirmation; // Add this field

  MoodLogAIEntity({
    this.suggestion,
    this.title, // Add this field
    this.affirmation, // Add this field
  });
}

class MoodLogEntity {
  final String id;
  final DateTime timestamp;
  final int moodRating;
  String? comment;
  final List<FeelingEntity>? feelings;
  final List<String>? factors;
  final List<MoodLogAttachmentEntity>? attachments;
  final MoodLogAIEntity? ai;

  MoodLogEntity({
    required this.id,
    required this.timestamp,
    required this.moodRating,
    this.feelings,
    this.comment,
    this.factors,
    this.attachments, // Initialize the new field
    this.ai,
  });

  // CopyWith method for immutability
  MoodLogEntity copyWith({
    String? id,
    DateTime? timestamp,
    int? moodRating,
    String? comment,
    List<FeelingEntity>? feelings,
    List<String>? factors,
    List<MoodLogAttachmentEntity>? attachments,
    MoodLogAIEntity? ai,
  }) {
    return MoodLogEntity(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodRating: moodRating ?? this.moodRating,
      comment: comment ?? this.comment,
      feelings: feelings ?? this.feelings,
      factors: factors ?? this.factors,
      attachments: attachments ?? this.attachments,
      ai: ai ?? this.ai,
    );
  }
}
