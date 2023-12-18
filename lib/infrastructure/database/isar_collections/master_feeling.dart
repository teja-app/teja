import 'package:isar/isar.dart';

part 'master_feeling.g.dart';

@Collection()
class MasterFeeling {
  Id isarId = Isar.autoIncrement;

  late String slug;
  late String name;
  late String type; // New field for category, subcategory, or feeling
  String? parentSlug; // New field, nullable for categories without a parent

  int? energy; // Now nullable, specific to 'feeling' type
  int? pleasantness; // Now nullable, specific to 'feeling' type
}
