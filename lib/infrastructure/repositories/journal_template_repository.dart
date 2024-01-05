import 'package:isar/isar.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_template.dart';

class JournalTemplateRepository {
  final Isar isar;

  JournalTemplateRepository(this.isar);

  Future<List<JournalTemplateEntity>> getAllTemplateEntities() async {
    var isarTemplates = await isar.journalTemplates.where().findAll();

    return isarTemplates.map((isarTemplate) {
      final meta = MetaDataEntity(
        version: isarTemplate.meta.version,
        author: isarTemplate.meta.author,
      );
      return JournalTemplateEntity(
        id: isarTemplate.id,
        templateID: isarTemplate.templateID,
        title: isarTemplate.title,
        questions: isarTemplate.questions
            .map((q) => JournalQuestionEntity(
                  id: q.id,
                  text: q.text,
                  type: q.type,
                  placeholder: q.placeholder ?? "",
                ))
            .toList(),
        meta: meta,
      );
    }).toList();
  }

  Future<JournalTemplateEntity?> getJournalTemplateById(String templateId) async {
    var isarTemplate = await isar.journalTemplates.where().templateIDEqualTo(templateId).findFirst();
    print("isarTemplate ${isarTemplate?.questions}");
    if (isarTemplate != null) {
      final meta = MetaDataEntity(
        version: isarTemplate.meta.version,
        author: isarTemplate.meta.author,
      );
      return JournalTemplateEntity(
        id: isarTemplate.id,
        templateID: isarTemplate.templateID,
        title: isarTemplate.title,
        questions: isarTemplate.questions
            .map((q) => JournalQuestionEntity(
                  id: q.id,
                  text: q.text,
                  type: q.type,
                  placeholder: q.placeholder ?? "",
                ))
            .toList(),
        meta: meta,
      );
    }
    return null; // Return null if the template is not found
  }

  Future<void> addOrUpdateJournalTemplates(List<JournalTemplateEntity> templates) async {
    await isar.writeTxn(() async {
      for (var template in templates) {
        final existingTemplate = await isar.journalTemplates.where().templateIDEqualTo(template.templateID).findFirst();

        if (existingTemplate != null) {
          // Update existing template
          existingTemplate
            ..id = template.id
            ..templateID = template.templateID
            ..title = template.title
            ..meta.version = template.meta.version
            ..meta.author = template.meta.author
            ..questions = template.questions
                .map((q) => JournalTemplateQuestion()
                  ..id = q.id
                  ..text = q.text
                  ..type = q.type
                  ..placeholder = q.placeholder)
                .toList();

          await isar.journalTemplates.put(existingTemplate);
        } else {
          // Create a new template
          final meta = MetaData()
            ..version = template.meta.version
            ..author = template.meta.author;
          final isarTemplate = JournalTemplate()
            ..id = template.id
            ..templateID = template.templateID
            ..title = template.title
            ..meta = meta
            ..questions = template.questions
                .map((q) => JournalTemplateQuestion()
                  ..id = q.id
                  ..text = q.text
                  ..type = q.type
                  ..placeholder = q.placeholder)
                .toList();

          await isar.journalTemplates.put(isarTemplate);
        }
      }
    });
  }
}
