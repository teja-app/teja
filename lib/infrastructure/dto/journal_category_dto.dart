import 'package:json_annotation/json_annotation.dart';

part 'journal_category_dto.g.dart';

@JsonSerializable()
class JournalCategoryDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  final FeaturedImageDto? featureImage;

  JournalCategoryDto({
    required this.id,
    required this.name,
    required this.description,
    this.featureImage,
  });

  factory JournalCategoryDto.fromJson(Map<String, dynamic> json) => _$JournalCategoryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JournalCategoryDtoToJson(this);
}

@JsonSerializable()
class FeaturedImageDto {
  final ImageSizesDto sizes;
  final String alt;
  final String filename;

  FeaturedImageDto({
    required this.sizes,
    required this.alt,
    required this.filename,
  });

  factory FeaturedImageDto.fromJson(Map<String, dynamic> json) => _$FeaturedImageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FeaturedImageDtoToJson(this);
}

@JsonSerializable()
class ImageSizesDto {
  final ImageDetailDto thumbnail;
  final ImageDetailDto card;

  ImageSizesDto({
    required this.thumbnail,
    required this.card,
  });

  factory ImageSizesDto.fromJson(Map<String, dynamic> json) => _$ImageSizesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ImageSizesDtoToJson(this);
}

@JsonSerializable()
class ImageDetailDto {
  final int? width;
  final int? height;
  final String? mimeType;
  final int? filesize;
  final String? filename;

  ImageDetailDto({
    this.width,
    this.height,
    this.mimeType,
    this.filesize,
    this.filename,
  });

  factory ImageDetailDto.fromJson(Map<String, dynamic> json) {
    return ImageDetailDto(
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      mimeType: json['mimeType'] as String? ?? 'image/png',
      filesize: json['filesize'] as int? ?? 0,
      filename: json['filename'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$ImageDetailDtoToJson(this);
}
