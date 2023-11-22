import 'package:isar/isar.dart';

part 'master_feeling_factor.g.dart';

@Collection()
class FeelingFactor {
  Id isarId = Isar.autoIncrement;

  late int feelingId;
  late int factorId;
}
