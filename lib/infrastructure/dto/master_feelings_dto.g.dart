// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_feelings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterFeelingDto _$MasterFeelingDtoFromJson(Map<String, dynamic> json) =>
    MasterFeelingDto(
      slug: json['slug'] as String,
      name: json['name'] as String,
      moodId: json['mood_id'] as int,
      description: json['description'] as String,
    );

Map<String, dynamic> _$MasterFeelingDtoToJson(MasterFeelingDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'mood_id': instance.moodId,
    };
