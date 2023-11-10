import 'package:isar/isar.dart';

part 'master_feeling.g.dart';

@Collection()
class MasterFeeling {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  @Index(unique: true)
  late String slug;

  late String name;
  late int moodId;
}
