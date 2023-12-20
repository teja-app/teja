// lib/domain/entities/mood_log.dart
import 'package:teja/domain/entities/feeling.dart';

class MoodLogEntity {
  final String id;
  final DateTime timestamp;
  final int moodRating;
  String? comment;
  final List<FeelingEntity>? feelings;
  final List<String>? factors; // New field for broad factors

  MoodLogEntity({
    required this.id,
    required this.timestamp,
    required this.moodRating,
    this.feelings,
    this.comment,
    this.factors, // Initialize the new field
  });

  // CopyWith method for immutability
  MoodLogEntity copyWith({
    String? id,
    DateTime? timestamp,
    int? moodRating,
    String? comment,
    List<FeelingEntity>? feelings,
    List<String>? factors,
  }) {
    return MoodLogEntity(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodRating: moodRating ?? this.moodRating,
      comment: comment ?? this.comment,
      feelings: feelings ?? this.feelings,
      factors: factors ?? this.factors,
    );
  }
}
