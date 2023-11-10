// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodLogModelDto _$MoodLogModelDtoFromJson(Map<String, dynamic> json) =>
    MoodLogModelDto(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      moodRating: json['moodRating'] as int,
      comment: json['comment'] as String,
      feelings: (json['feelings'] as List<dynamic>)
          .map((e) => FeelingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MoodLogModelDtoToJson(MoodLogModelDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'moodRating': instance.moodRating,
      'comment': instance.comment,
      'feelings': instance.feelings,
    };
