import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

import 'package:teja/domain/entities/journal_template_entity.dart'; // Ensure this entity is defined
import 'package:teja/infrastructure/dto/journal_template_dto.dart'; // Updated DTO file

class JournalTemplateApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<JournalTemplateEntity>> getJournalTemplates(String? authToken) async {
    const String url = '/journal-templates';
    Response response = await _apiHelper.get(url, authToken: authToken);
    List<dynamic> jsonResponse = response.data;

    List<JournalTemplateEntity> journalTemplates = jsonResponse.map((json) {
      JournalTemplateDto journalTemplateDto = JournalTemplateDto.fromJson(json);
      return _convertDtoToEntity(journalTemplateDto);
    }).toList();

    return Future(() => journalTemplates);
  }

  JournalTemplateEntity _convertDtoToEntity(JournalTemplateDto dto) {
    List<JournalQuestionEntity> questions = dto.questions.map((qDto) {
      return JournalQuestionEntity(
        id: qDto.id,
        text: qDto.text,
        type: qDto.type,
        placeholder: qDto.placeholder ?? 'Default Placeholder', // Added default value
      );
    }).toList();

    MetaDataEntity meta = MetaDataEntity(
      version: dto.meta.version,
      author: dto.meta.author,
    );

    return JournalTemplateEntity(
      id: dto.id,
      templateID: dto.templateID,
      title: dto.header.title,
      category: dto.category ?? "",
      description: dto.header.description ?? "",
      questions: questions,
      meta: meta,
    );
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
