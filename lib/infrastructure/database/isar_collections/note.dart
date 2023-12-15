import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'note.g.dart';

@Collection()
class NotesIsarCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  DateTime timestamp = DateTime.now();
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  String? title;
  String? text;
  bool archieved = false;
  bool isLinked = false;
}
