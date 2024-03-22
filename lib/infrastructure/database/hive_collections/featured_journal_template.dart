import 'package:hive/hive.dart';
import 'package:teja/infrastructure/database/hive_collections/constants.dart';

part 'featured_journal_template.g.dart';

@HiveType(typeId: featuredJournalTemplate)
class FeaturedJournalTemplate {
  static const String boxKey = 'featuredJournalTemplate';

  @HiveField(1)
  late String template;

  @HiveField(2)
  late bool featured;

  @HiveField(3)
  late int priority;

  @HiveField(4)
  late bool active;
}
