import 'package:json_annotation/json_annotation.dart';

part 'journal_category_dto.g.dart';

@JsonSerializable()
class JournalCategoryDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  final FeaturedImageDto? featureImage;
  final bool isFeatured;

  JournalCategoryDto({
    required this.id,
    required this.name,
    required this.description,
    this.featureImage,
    required this.isFeatured,
  });

  factory JournalCategoryDto.fromJson(Map<String, dynamic> json) {
    return JournalCategoryDto(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      featureImage: json['featureImage'] != null
          ? FeaturedImageDto.fromJson(json['featureImage'])
          : null,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'featureImage': featureImage?.toJson(),
      'isFeatured': isFeatured,
    };
  }
}

@JsonSerializable()
class FeaturedImageDto {
  final ImageSizesDto sizes;

  FeaturedImageDto({
    required this.sizes,
  });

  factory FeaturedImageDto.fromJson(Map<String, dynamic> json) =>
      _$FeaturedImageDtoFromJson(json);
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

  factory ImageSizesDto.fromJson(Map<String, dynamic> json) =>
      _$ImageSizesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ImageSizesDtoToJson(this);
}

@JsonSerializable()
class ImageDetailDto {
  final int? width;
  final int? height;
  final String? mimeType;
  final int? filesize;
  final String? filename;
  final String? url;

  ImageDetailDto({
    this.width,
    this.height,
    this.mimeType,
    this.filesize,
    this.filename,
    this.url,
  });

  factory ImageDetailDto.fromJson(Map<String, dynamic> json) {
    return ImageDetailDto(
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      mimeType: json['mimeType'] as String? ?? 'image/png',
      filesize: json['filesize'] as int? ?? 0,
      filename: json['filename'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$ImageDetailDtoToJson(this);
}
