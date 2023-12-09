import 'package:isar/isar.dart';

part 'master_feeling.g.dart';

@Collection()
class MasterFeeling {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String slug;

  late String name;
  late int energy;
  late int pleasantness;
}
