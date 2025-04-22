import 'package:collection/collection.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as cbl;

/// Repository for managing video entries using Couchbase Lite
class VideoEntryRepository {
  final Database database;

  VideoEntryRepository(this.database);

  /// Add or update a video entry for a journal entry
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [newVideo] The video entry to add or update
  Future<void> addOrUpdateVideo(String journalEntryId, cbl.VideoEntry newVideo) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing video entries or create an empty list
          List<Map<String, dynamic>> videoEntries = [];
          if (existingData.containsKey('videoEntries')) {
            videoEntries = (existingData['videoEntries'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];
          }

          // Check if the video already exists
          final existingIndex = videoEntries.indexWhere((vid) => vid['hash'] == newVideo.hash);
          if (existingIndex == -1) {
            // Convert the new video to a map and add it
            final videoMap = {
              'id': newVideo.id,
              'filePath': newVideo.filePath,
              'duration': newVideo.duration,
              'hash': newVideo.hash,
            };
            videoEntries.add(videoMap);
          }

          // Update the video entries in the existing data
          existingData['videoEntries'] = videoEntries;
          existingData['updatedAt'] = DateTime.now().toIso8601String();

          // Set all data at once
          mutableDoc.setData(existingData);

          // Save the document
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error adding or updating video: $e');
      throw Exception('Failed to save video: $e');
    }
  }

  /// Find a video entry by its hash
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [hash] The hash of the video to find
  /// Returns the video entry or null if not found
  Future<cbl.VideoEntry?> findVideoByHash(String journalEntryId, String hash) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(journalEntryId);

      if (doc != null) {
        final data = doc.toPlainMap();
        if (data.containsKey('videoEntries')) {
          final videoEntries =
              (data['videoEntries'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
          final videoMap = videoEntries.firstWhereOrNull((vid) => vid['hash'] == hash);

          if (videoMap != null) {
            return cbl.VideoEntry(
              id: videoMap['id'],
              filePath: videoMap['filePath'],
              duration: videoMap['duration'],
              hash: videoMap['hash'],
            );
          }
        }
      }
      return null;
    } catch (e) {
      print('Error finding video by hash: $e');
      return null;
    }
  }

  /// Remove a video entry from a journal entry
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [videoHash] The hash of the video to remove
  Future<void> removeVideo(String journalEntryId, String videoHash) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing video entries
          if (existingData.containsKey('videoEntries')) {
            List<Map<String, dynamic>> videoEntries = (existingData['videoEntries'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];

            // Remove the video with the matching hash
            videoEntries.removeWhere((vid) => vid['hash'] == videoHash);

            // Update the video entries in the existing data
            existingData['videoEntries'] = videoEntries;
            existingData['updatedAt'] = DateTime.now().toIso8601String();

            // Set all data at once
            mutableDoc.setData(existingData);

            // Save the document
            await collection.saveDocument(mutableDoc);
          }
        }
      });
    } catch (e) {
      print('Error removing video: $e');
      throw Exception('Failed to remove video: $e');
    }
  }

  /// Link a video to a question-answer pair
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [questionAnswerPairId] The ID of the question-answer pair
  /// [videoId] The ID of the video to link
  Future<void> linkVideoToQuestionAnswerPair(String journalEntryId, String questionAnswerPairId, String videoId) async {
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
              // Get the video entry IDs or create an empty list
              List<String> videoEntryIds = List<String>.from(questions[questionIndex]['videoEntryIds'] ?? []);

              // Add the video ID if it doesn't already exist
              if (!videoEntryIds.contains(videoId)) {
                videoEntryIds.add(videoId);

                // Update the question-answer pair
                questions[questionIndex]['videoEntryIds'] = videoEntryIds;

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
      print('Error linking video to question-answer pair: $e');
      throw Exception('Failed to link video: $e');
    }
  }

  /// Unlink a video from a question-answer pair
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [questionAnswerPairId] The ID of the question-answer pair
  /// [videoId] The ID of the video to unlink
  Future<void> unlinkVideoFromQuestionAnswerPair(
      String journalEntryId, String questionAnswerPairId, String videoId) async {
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
            if (questionIndex != -1 && questions[questionIndex].containsKey('videoEntryIds')) {
              // Get the video entry IDs
              List<String> videoEntryIds = List<String>.from(questions[questionIndex]['videoEntryIds'] ?? []);

              // Remove the video ID
              videoEntryIds.removeWhere((id) => id == videoId);

              // Update the question-answer pair
              questions[questionIndex]['videoEntryIds'] = videoEntryIds;

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
      print('Error unlinking video from question-answer pair: $e');
      throw Exception('Failed to unlink video: $e');
    }
  }
}
