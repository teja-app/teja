import 'package:isar/isar.dart';

part 'master_factor.g.dart';

@Collection()
class MasterFactor {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String slug;

  late String name;
  late String categoryId;
}
