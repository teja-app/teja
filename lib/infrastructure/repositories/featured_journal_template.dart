import 'package:hive/hive.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/infrastructure/database/hive_collections/featured_journal_template.dart';

class FeaturedJournalTemplateRepository {
  late Box<FeaturedJournalTemplate> _box;

  Future<List<FeaturedJournalTemplateEntity>> getAllFeaturedTemplateEntities() async {
    final box = Hive.box(FeaturedJournalTemplate.boxKey);
    return box.values.map((hiveTemplate) {
      final key = box.keyAt(box.values.toList().indexOf(hiveTemplate)).toString();
      return FeaturedJournalTemplateEntity(
        id: key,
        template: hiveTemplate.template,
        featured: hiveTemplate.featured,
        priority: hiveTemplate.priority,
        active: hiveTemplate.active,
      );
    }).toList();
  }

  Future<void> clearFeaturedJournalTemplates() async {
    await Hive.box(FeaturedJournalTemplate.boxKey).clear();
  }

  Future<void> addOrUpdateFeaturedJournalTemplates(List<FeaturedJournalTemplateEntity> templates) async {
    var box = Hive.box(FeaturedJournalTemplate.boxKey); // Ensure the box is initialized
    for (var templateEntity in templates) {
      var hiveTemplate = FeaturedJournalTemplate()
        ..template = templateEntity.template
        ..featured = templateEntity.featured
        ..priority = templateEntity.priority
        ..active = templateEntity.active;
      // Use the entity's id as the key for the Hive box entry
      await box.put(templateEntity.id, hiveTemplate);
    }
  }
}
