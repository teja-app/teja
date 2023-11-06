// lib/infrastructure/utils/helpers.dart
import 'package:uuid/uuid.dart';

class Helpers {
  // Generates a unique identifier
  static String generateUniqueId() {
    // This could be a UUID or any other format you'd like
    final uuid = Uuid().v7();
    return uuid;
  }

  // ... Any other utility methods can be added here
}
