import 'package:isar/isar.dart';

part 'master_factor.g.dart';

@Embedded()
class SubCategory {
  late String slug;
  late String title;
}

@Collection()
class MasterFactor {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String slug;

  late String title;

  List<SubCategory>? subcategories;
}
