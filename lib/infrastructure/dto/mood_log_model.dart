import 'package:json_annotation/json_annotation.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/infrastructure/dto/feeling_dto.dart';

part 'mood_log_model.g.dart';

@JsonSerializable()
class MoodLogModelDto {
  final String id;
  final DateTime timestamp;
  final int moodRating;
  final String comment;
  final List<FeelingDto> feelings; // Change to List<FeelingDto>

  MoodLogModelDto({
    required this.id,
    required this.timestamp,
    required this.moodRating,
    required this.comment,
    required this.feelings,
  });

  factory MoodLogModelDto.fromJson(Map<String, dynamic> json) => _$MoodLogModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MoodLogModelDtoToJson(this);

  // Convert DTO to domain entity
  MoodLogEntity toDomain() {
    return MoodLogEntity(
      id: id,
      timestamp: timestamp,
      moodRating: moodRating,
      comment: comment,
      feelings: feelings.map((dto) => dto.toDomain()).toList(), // Map DTO to domain
    );
  }
}
