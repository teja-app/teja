import 'package:isar/isar.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/featured_journal_template.dart';

class FeaturedJournalTemplateRepository {
  final Isar isar;

  FeaturedJournalTemplateRepository(this.isar);

  Future<List<FeaturedJournalTemplateEntity>> getAllFeaturedTemplateEntities() async {
    var isarTemplates = await isar.featuredJournalTemplates.where().sortByPriority().findAll();

    return isarTemplates.map((isarTemplate) {
      return FeaturedJournalTemplateEntity(
        id: isarTemplate.id,
        template: isarTemplate.template,
        featured: isarTemplate.featured,
        priority: isarTemplate.priority,
        active: isarTemplate.active,
      );
    }).toList();
  }

  Future<FeaturedJournalTemplateEntity?> getFeaturedJournalTemplateById(String template) async {
    var isarTemplate = await isar.featuredJournalTemplates.where().templateEqualTo(template).findFirst();
    if (isarTemplate != null) {
      return FeaturedJournalTemplateEntity(
        id: isarTemplate.id,
        template: isarTemplate.template,
        featured: isarTemplate.featured,
        priority: isarTemplate.priority,
        active: isarTemplate.active,
      );
    }
    return null; // Return null if the template is not found
  }

  Future<void> clearFeaturedJournalTemplates() async {
    await isar.writeTxn(() async {
      await isar.featuredJournalTemplates.clear();
    });
  }

  Future<void> addOrUpdateFeaturedJournalTemplates(List<FeaturedJournalTemplateEntity> templates) async {
    await isar.writeTxn(() async {
      for (var template in templates) {
        final existingTemplate =
            await isar.featuredJournalTemplates.where().templateEqualTo(template.template).findFirst();

        if (existingTemplate != null) {
          // Update existing template
          existingTemplate
            ..template = template.template
            ..featured = template.featured
            ..priority = template.priority
            ..active = template.active;

          await isar.featuredJournalTemplates.put(existingTemplate);
        } else {
          // Create a new template
          final isarTemplate = FeaturedJournalTemplate()
            ..template = template.template
            ..featured = template.featured
            ..priority = template.priority
            ..active = template.active;

          await isar.featuredJournalTemplates.put(isarTemplate);
        }
      }
    });
  }
}
