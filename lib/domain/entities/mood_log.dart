// lib/domain/entities/mood_log.dart
import 'package:swayam/domain/entities/feeling.dart';

class MoodLogEntity {
  final String id;
  final DateTime timestamp;
  final int moodRating;
  String? comment;
  final List<FeelingEntity>? feelings;

  MoodLogEntity({
    required this.id,
    required this.timestamp,
    required this.moodRating,
    this.feelings,
    this.comment,
  });

  // CopyWith method for immutability
  MoodLogEntity copyWith({
    String? id,
    DateTime? timestamp,
    int? moodRating,
    String? comment,
    List<FeelingEntity>? feelings,
  }) {
    return MoodLogEntity(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodRating: moodRating ?? this.moodRating,
      comment: comment ?? this.comment,
      feelings: feelings ?? this.feelings,
    );
  }
}
