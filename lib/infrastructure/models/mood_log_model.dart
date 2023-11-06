import 'package:json_annotation/json_annotation.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/infrastructure/models/feeling_model.dart';

part 'mood_log_model.g.dart';

@JsonSerializable()
class MoodLogModel extends MoodLog {
  MoodLogModel({
    required String id,
    required DateTime timestamp,
    required int moodRating,
    required String comment,
    required List<FeelingModel> feelings,
  }) : super(
          id: id,
          timestamp: timestamp,
          moodRating: moodRating,
          comment: comment,
          feelings: feelings,
        );

  factory MoodLogModel.fromJson(Map<String, dynamic> json) =>
      _$MoodLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoodLogModelToJson(this);

  // Additional methods for database operations could also be added here.
}
