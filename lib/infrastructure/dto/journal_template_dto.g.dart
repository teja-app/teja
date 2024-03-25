// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalTemplateDto _$JournalTemplateDtoFromJson(Map<String, dynamic> json) =>
    JournalTemplateDto(
      id: json['_id'] as String,
      templateID: json['templateID'] as String,
      header: HeaderDto.fromJson(json['header'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => JournalQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaDataDto.fromJson(json['meta'] as Map<String, dynamic>),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$JournalTemplateDtoToJson(JournalTemplateDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'templateID': instance.templateID,
      'header': instance.header,
      'questions': instance.questions,
      'meta': instance.meta,
      'category': instance.category,
    };

HeaderDto _$HeaderDtoFromJson(Map<String, dynamic> json) => HeaderDto(
      title: json['title'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$HeaderDtoToJson(HeaderDto instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

JournalQuestionDto _$JournalQuestionDtoFromJson(Map<String, dynamic> json) =>
    JournalQuestionDto(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      placeholder: json['placeholder'] as String?,
    );

Map<String, dynamic> _$JournalQuestionDtoToJson(JournalQuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
      'placeholder': instance.placeholder,
    };

MetaDataDto _$MetaDataDtoFromJson(Map<String, dynamic> json) => MetaDataDto(
      version: json['version'] as String,
      author: json['author'] as String,
    );

Map<String, dynamic> _$MetaDataDtoToJson(MetaDataDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'author': instance.author,
    };
