// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalCategoryDto _$JournalCategoryDtoFromJson(Map<String, dynamic> json) =>
    JournalCategoryDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      featureImage: json['featureImage'] == null
          ? null
          : FeaturedImageDto.fromJson(
              json['featureImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JournalCategoryDtoToJson(JournalCategoryDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'featureImage': instance.featureImage,
    };

FeaturedImageDto _$FeaturedImageDtoFromJson(Map<String, dynamic> json) =>
    FeaturedImageDto(
      sizes: ImageSizesDto.fromJson(json['sizes'] as Map<String, dynamic>),
      alt: json['alt'] as String,
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$FeaturedImageDtoToJson(FeaturedImageDto instance) =>
    <String, dynamic>{
      'sizes': instance.sizes,
      'alt': instance.alt,
      'filename': instance.filename,
    };

ImageSizesDto _$ImageSizesDtoFromJson(Map<String, dynamic> json) =>
    ImageSizesDto(
      thumbnail:
          ImageDetailDto.fromJson(json['thumbnail'] as Map<String, dynamic>),
      card: ImageDetailDto.fromJson(json['card'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImageSizesDtoToJson(ImageSizesDto instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'card': instance.card,
    };

ImageDetailDto _$ImageDetailDtoFromJson(Map<String, dynamic> json) =>
    ImageDetailDto(
      width: json['width'] as int?,
      height: json['height'] as int?,
      mimeType: json['mimeType'] as String?,
      filesize: json['filesize'] as int?,
      filename: json['filename'] as String?,
    );

Map<String, dynamic> _$ImageDetailDtoToJson(ImageDetailDto instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'mimeType': instance.mimeType,
      'filesize': instance.filesize,
      'filename': instance.filename,
    };
