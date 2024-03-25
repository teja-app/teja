import 'package:hive/hive.dart';
import 'package:teja/infrastructure/database/hive_collections/constants.dart';

part 'journal_category.g.dart'; // This file is generated automatically by Hive

@HiveType(typeId: journalCategoryTypeId)
class JournalCategory {
  static const String boxKey = 'journalCategory';

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String? description;

  @HiveField(3)
  late String? featureImage; // This is a JSON string
}
