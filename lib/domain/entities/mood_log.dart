// lib/domain/entities/mood_log.dart
import 'package:swayam/domain/entities/feeling.dart';

class MoodLog {
  final String id;
  final DateTime timestamp;
  final int moodRating;
  final String comment;
  final List<Feeling> feelings;

  MoodLog({
    required this.id,
    required this.timestamp,
    required this.moodRating,
    required this.comment,
    required this.feelings,
  });

  // CopyWith method for immutability
  MoodLog copyWith({
    String? id,
    DateTime? timestamp,
    int? moodRating,
    String? comment,
    List<Feeling>? feelings,
  }) {
    return MoodLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodRating: moodRating ?? this.moodRating,
      comment: comment ?? this.comment,
      feelings: feelings ?? this.feelings,
    );
  }
}
