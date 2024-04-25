import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VoiceStorageHelper {
  /// Saves a voice recording permanently to the app's documents directory.
  /// Returns the relative path of the saved voice recording.
  static Future<String> saveVoicePermanently(String voicePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final name = path.basename(voicePath);
      final newVoicePath = path.join(directory.path, name);

      final File sourceFile = File(voicePath);
      if (await sourceFile.exists()) {
        final File newVoiceFile = await sourceFile.copy(newVoicePath);
        return path.relative(newVoiceFile.path, from: directory.path);
      } else {
        throw Exception('Voice recording file not found: $voicePath');
      }
    } catch (e) {
      print('Error saving voice recording permanently: $e');
      rethrow;
    }
  }

  static Future<File> getVoice(String relativePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final voicePath = path.join(directory.path, relativePath);
    final file = File(voicePath);
    if (await file.exists()) {
      return file;
    } else {
      throw Exception('Voice recording file not found: $voicePath');
    }
  }
}
