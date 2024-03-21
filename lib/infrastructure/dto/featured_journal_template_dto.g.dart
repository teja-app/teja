// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_journal_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedJournalTemplateDto _$FeaturedJournalTemplateDtoFromJson(
        Map<String, dynamic> json) =>
    FeaturedJournalTemplateDto(
      id: json['_id'] as String,
      template: json['template'] as String,
      featured: json['featured'] as bool,
      priority: json['priority'] as int,
      active: json['active'] as bool? ?? false,
    );

Map<String, dynamic> _$FeaturedJournalTemplateDtoToJson(
        FeaturedJournalTemplateDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'template': instance.template,
      'featured': instance.featured,
      'priority': instance.priority,
      'active': instance.active,
    };
