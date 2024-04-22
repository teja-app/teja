import 'package:uuid/uuid.dart';
import 'dart:convert'; // for utf8 encode
import 'package:crypto/crypto.dart'; // for hashing

class Helpers {
  // Generates a unique identifier using UUID v7
  static String generateUniqueId() {
    final uuid = const Uuid().v7();
    return uuid;
  }

  // Updated to accept bytes directly
  static String generateHash(List<int> bytes) {
    var digest = sha256.convert(bytes); // Hashing using SHA-256
    return digest.toString();
  }
}
