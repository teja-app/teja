// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteDto _$QuoteDtoFromJson(Map<String, dynamic> json) => QuoteDto(
      id: json['_id'] as String,
      author: json['author'] as String,
      source: json['source'] as String,
      text: json['text'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );

Map<String, dynamic> _$QuoteDtoToJson(QuoteDto instance) => <String, dynamic>{
      '_id': instance.id,
      'author': instance.author,
      'source': instance.source,
      'text': instance.text,
      'tags': instance.tags,
    };
