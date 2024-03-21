import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'featured_journal_template.g.dart';

@Collection()
class FeaturedJournalTemplate {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id = Helpers.generateUniqueId(); // Unique identifier for the featured journal template

  @Index()
  late String template;
  late bool featured;
  late int priority;
  late bool active;
}
