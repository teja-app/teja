import 'package:collection/collection.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as cbl;

/// Repository for managing image entries using Couchbase Lite
class ImageEntryRepository {
  final Database database;

  ImageEntryRepository(this.database);

  /// Add or update an image entry for a journal entry
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [newImage] The image entry to add or update
  Future<void> addOrUpdateImage(String journalEntryId, cbl.ImageEntry newImage) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing image entries or create an empty list
          List<Map<String, dynamic>> imageEntries = [];
          if (existingData.containsKey('imageEntries')) {
            imageEntries = (existingData['imageEntries'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];
          }

          // Check if the image already exists
          final existingIndex = imageEntries.indexWhere((img) => img['hash'] == newImage.hash);
          if (existingIndex == -1) {
            // Convert the new image to a map and add it
            final imageMap = {
              'id': newImage.id,
              'filePath': newImage.filePath,
              'caption': newImage.caption,
              'hash': newImage.hash,
            };
            imageEntries.add(imageMap);
          }

          // Update the image entries in the existing data
          existingData['imageEntries'] = imageEntries;
          existingData['updatedAt'] = DateTime.now().toIso8601String();

          // Set all data at once
          mutableDoc.setData(existingData);

          // Save the document
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Find an image entry by its hash
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [hash] The hash of the image to find
  /// Returns the image entry or null if not found
  Future<cbl.ImageEntry?> findImageByHash(String journalEntryId, String hash) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(journalEntryId);

      if (doc != null) {
        final data = doc.toPlainMap();
        if (data.containsKey('imageEntries')) {
          final imageEntries =
              (data['imageEntries'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
          final imageMap = imageEntries.firstWhereOrNull((img) => img['hash'] == hash);

          if (imageMap != null) {
            return cbl.ImageEntry(
              id: imageMap['id'],
              filePath: imageMap['filePath'],
              caption: imageMap['caption'],
              hash: imageMap['hash'],
            );
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Remove an image entry from a journal entry
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [imageHash] The hash of the image to remove
  Future<void> removeImage(String journalEntryId, String imageHash) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing image entries
          if (existingData.containsKey('imageEntries')) {
            List<Map<String, dynamic>> imageEntries = (existingData['imageEntries'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];

            // Remove the image with the matching hash
            imageEntries.removeWhere((img) => img['hash'] == imageHash);

            // Update the image entries in the existing data
            existingData['imageEntries'] = imageEntries;
            existingData['updatedAt'] = DateTime.now().toIso8601String();

            // Set all data at once
            mutableDoc.setData(existingData);

            // Save the document
            await collection.saveDocument(mutableDoc);
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to remove image: $e');
    }
  }

  /// Link an image to a question-answer pair
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [questionAnswerPairId] The ID of the question-answer pair
  /// [imageId] The ID of the image to link
  Future<void> linkImageToQuestionAnswerPair(String journalEntryId, String questionAnswerPairId, String imageId) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing questions
          if (existingData.containsKey('questions')) {
            List<Map<String, dynamic>> questions = (existingData['questions'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];

            // Find the question-answer pair
            final questionIndex = questions.indexWhere((q) => q['id'] == questionAnswerPairId);
            if (questionIndex != -1) {
              // Get the image entry IDs or create an empty list
              List<String> imageEntryIds = List<String>.from(questions[questionIndex]['imageEntryIds'] ?? []);

              // Add the image ID if it doesn't already exist
              if (!imageEntryIds.contains(imageId)) {
                imageEntryIds.add(imageId);

                // Update the question-answer pair
                questions[questionIndex]['imageEntryIds'] = imageEntryIds;

                // Update the questions in the existing data
                existingData['questions'] = questions;
                existingData['updatedAt'] = DateTime.now().toIso8601String();

                // Set all data at once
                mutableDoc.setData(existingData);

                // Save the document
                await collection.saveDocument(mutableDoc);
              }
            }
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to link image: $e');
    }
  }

  /// Unlink an image from a question-answer pair
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [questionAnswerPairId] The ID of the question-answer pair
  /// [imageId] The ID of the image to unlink
  Future<void> unlinkImageFromQuestionAnswerPair(
      String journalEntryId, String questionAnswerPairId, String imageId) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing questions
          if (existingData.containsKey('questions')) {
            List<Map<String, dynamic>> questions = (existingData['questions'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];

            // Find the question-answer pair
            final questionIndex = questions.indexWhere((q) => q['id'] == questionAnswerPairId);
            if (questionIndex != -1 && questions[questionIndex].containsKey('imageEntryIds')) {
              // Get the image entry IDs
              List<String> imageEntryIds = List<String>.from(questions[questionIndex]['imageEntryIds'] ?? []);

              // Remove the image ID
              imageEntryIds.removeWhere((id) => id == imageId);

              // Update the question-answer pair
              questions[questionIndex]['imageEntryIds'] = imageEntryIds;

              // Update the questions in the existing data
              existingData['questions'] = questions;
              existingData['updatedAt'] = DateTime.now().toIso8601String();

              // Set all data at once
              mutableDoc.setData(existingData);

              // Save the document
              await collection.saveDocument(mutableDoc);
            }
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to unlink image: $e');
    }
  }
}
