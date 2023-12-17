// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_feelings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterFeelingDto _$MasterFeelingDtoFromJson(Map<String, dynamic> json) =>
    MasterFeelingDto(
      slug: json['slug'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      parentSlug: json['parent_slug'] as String?,
      energy: json['energy'] as int?,
      pleasantness: json['pleasantness'] as int?,
    );

Map<String, dynamic> _$MasterFeelingDtoToJson(MasterFeelingDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'parent_slug': instance.parentSlug,
      'type': instance.type,
      'energy': instance.energy,
      'pleasantness': instance.pleasantness,
    };
