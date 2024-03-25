import 'package:json_annotation/json_annotation.dart';

part 'journal_template_dto.g.dart'; // This file is generated automatically

@JsonSerializable()
class JournalTemplateDto {
  @JsonKey(name: '_id')
  final String id;
  final String templateID;
  HeaderDto header;

  final List<JournalQuestionDto> questions;
  final MetaDataDto meta;
  final String? category;

  JournalTemplateDto({
    required this.id,
    required this.templateID,
    required this.header,
    required this.questions,
    required this.meta,
    this.category,
  });

  factory JournalTemplateDto.fromJson(Map<String, dynamic> json) => _$JournalTemplateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JournalTemplateDtoToJson(this);
}

@JsonSerializable()
class HeaderDto {
  final String title;
  final String? description;

  HeaderDto({
    required this.title,
    required this.description,
  });

  factory HeaderDto.fromJson(Map<String, dynamic> json) => _$HeaderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderDtoToJson(this);
}

@JsonSerializable()
class JournalQuestionDto {
  final String id;
  final String text;
  final String type;
  final String? placeholder; // Ensure this is nullable

  JournalQuestionDto({
    required this.id,
    required this.text,
    required this.type,
    this.placeholder,
  });

  factory JournalQuestionDto.fromJson(Map<String, dynamic> json) => _$JournalQuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JournalQuestionDtoToJson(this);
}

@JsonSerializable()
class MetaDataDto {
  final String version;
  final String author;

  MetaDataDto({
    required this.version,
    required this.author,
  });

  factory MetaDataDto.fromJson(Map<String, dynamic> json) => _$MetaDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataDtoToJson(this);
}
