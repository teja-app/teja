import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'quote.g.dart';

@Collection()
class Quote {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  late String? author;
  late String? source;
  late String text;
  late List<String> tags; // Ensure that Isar supports the List<String> type
}
