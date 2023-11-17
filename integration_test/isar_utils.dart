// integration_test/isar_utils.dart
import 'dart:io';
import 'dart:math';
import 'package:isar/isar.dart';

String getRandomName() {
  var random = Random().nextInt(pow(2, 32) as int).toString();
  return '${random}_tmp';
}

Future<Isar> openTempIsar({
  required List<CollectionSchema<dynamic>> schemas,
  String? name,
}) async {
  await Isar.initializeIsarCore(download: true);

  return Isar.openSync(
    schemas,
    name: name ?? getRandomName(),
    directory: Directory.current.path,
  );
}
