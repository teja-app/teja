import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> writeSecureData(String key, String value) async {
  var secureStorage = const FlutterSecureStorage();
  await secureStorage.write(key: key, value: value);
}

// Wrapper for reading data from secure storage
Future<String?> readSecureData(String key) async {
  var secureStorage = const FlutterSecureStorage();
  return await secureStorage.read(key: key);
}

// Wrapper for deleting data from secure storage
Future<void> deleteSecureData(String key) async {
  var secureStorage = const FlutterSecureStorage();
  await secureStorage.delete(key: key);
}
