import 'package:json_annotation/json_annotation.dart';

part 'featured_journal_template_dto.g.dart'; // This file is generated automatically

@JsonSerializable()
class FeaturedJournalTemplateDto {
  @JsonKey(name: '_id')
  final String id;
  final String template; // Assuming a reference to the Journal Template ID
  final bool featured;
  final int priority;
  final bool active;

  FeaturedJournalTemplateDto({
    required this.id,
    required this.template,
    required this.featured,
    required this.priority,
    this.active = false,
  });

  factory FeaturedJournalTemplateDto.fromJson(Map<String, dynamic> json) => _$FeaturedJournalTemplateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedJournalTemplateDtoToJson(this);
}
