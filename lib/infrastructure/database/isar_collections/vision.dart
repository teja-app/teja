import 'package:isar/isar.dart';

part 'vision.g.dart';

@Collection()
class Vision {
  Id id = Isar.autoIncrement;

  late String slug;
  late int order;
}
