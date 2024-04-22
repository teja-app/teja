import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VideoStorageHelper {
  /// Saves a video permanently to the app's documents directory.
  /// Returns the relative path of the saved video.
  static Future<String> saveVideoPermanently(String videoPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final name = path.basename(videoPath);
      final newVideoPath = path.join(directory.path, name);
      final File newVideoFile = await File(videoPath).copy(newVideoPath);
      // Return the relative path to be stored in the database
      return path.relative(newVideoFile.path, from: directory.path);
    } catch (e) {
      print('Error saving video permanently: $e');
      rethrow;
    }
  }

  /// Retrieves a video using a relative path.
  /// Returns a File object for the video.
  static Future<File> getVideo(String relativePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final videoPath = path.join(directory.path, relativePath);
    return File(videoPath);
  }
}// TODO Implement this library.