// lib/infrastructure/api/featured_journal_template_api.dart
import 'package:dio/dio.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/featured_journal_template_dto.dart';

class FeaturedJournalTemplateApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<FeaturedJournalTemplateEntity>> getFeaturedJournalTemplates() async {
    const String url = '/featured-journal-templates';
    Response response = await _apiHelper.unsafeGet(url);
    List<dynamic> jsonResponse = response.data;
    print("jsonResponse $jsonResponse");

    List<FeaturedJournalTemplateEntity> featuredJournalTemplates = jsonResponse.map((json) {
      FeaturedJournalTemplateDto dto = FeaturedJournalTemplateDto.fromJson(json);
      return FeaturedJournalTemplateEntity(
        id: dto.id,
        template: dto.template,
        featured: dto.featured,
        priority: dto.priority,
        active: dto.active,
      );
    }).toList();
    return featuredJournalTemplates;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
