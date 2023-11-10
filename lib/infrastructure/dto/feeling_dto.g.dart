// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeling_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeelingDto _$FeelingDtoFromJson(Map<String, dynamic> json) => FeelingDto(
      feeling: json['feeling'] as String,
      comment: json['comment'] as String,
      factors:
          (json['factors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FeelingDtoToJson(FeelingDto instance) =>
    <String, dynamic>{
      'feeling': instance.feeling,
      'comment': instance.comment,
      'factors': instance.factors,
    };
