import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageStorageHelper {
  /// Saves an image permanently to the app's documents directory.
  /// Returns the relative path of the saved image.
  static Future<String> saveImagePermanently(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final name = path.basename(imagePath);
      final newImagePath = path.join(directory.path, name);
      final File newImageFile = await File(imagePath).copy(newImagePath);
      // Return the relative path to be stored in the database
      return path.relative(newImageFile.path, from: directory.path);
    } catch (e) {
      print('Error saving image permanently: $e');
      rethrow;
    }
  }

  /// Retrieves an image using a relative path.
  /// Returns a File object for the image.
  static Future<File> getImage(String relativePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = path.join(directory.path, relativePath);
    return File(imagePath);
  }
}
