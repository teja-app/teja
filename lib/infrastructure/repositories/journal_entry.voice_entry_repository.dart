import 'package:collection/collection.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as cbl;

/// Repository for managing voice entries using Couchbase Lite
class VoiceEntryRepository {
  final Database database;

  VoiceEntryRepository(this.database);

  /// Add or update a voice entry for a journal entry
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [newVoice] The voice entry to add or update
  Future<void> addOrUpdateVoice(String journalEntryId, cbl.VoiceEntry newVoice) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing voice entries or create an empty list
          List<Map<String, dynamic>> voiceEntries = [];
          if (existingData.containsKey('voiceEntries')) {
            voiceEntries = (existingData['voiceEntries'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];
          }

          // Check if the voice already exists
          final existingIndex = voiceEntries.indexWhere((voice) => voice['hash'] == newVoice.hash);
          if (existingIndex == -1) {
            // Convert the new voice to a map and add it
            final voiceMap = {
              'id': newVoice.id,
              'filePath': newVoice.filePath,
              'duration': newVoice.duration,
              'hash': newVoice.hash,
            };
            voiceEntries.add(voiceMap);
          }

          // Update the voice entries in the existing data
          existingData['voiceEntries'] = voiceEntries;
          existingData['updatedAt'] = DateTime.now().toIso8601String();

          // Set all data at once
          mutableDoc.setData(existingData);

          // Save the document
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      throw Exception('Failed to save voice: $e');
    }
  }

  /// Find a voice entry by its hash
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [hash] The hash of the voice to find
  /// Returns the voice entry or null if not found
  Future<cbl.VoiceEntry?> findVoiceByHash(String journalEntryId, String hash) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(journalEntryId);

      if (doc != null) {
        final data = doc.toPlainMap();
        if (data.containsKey('voiceEntries')) {
          final voiceEntries =
              (data['voiceEntries'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
          final voiceMap = voiceEntries.firstWhereOrNull((voice) => voice['hash'] == hash);

          if (voiceMap != null) {
            return cbl.VoiceEntry(
              id: voiceMap['id'],
              filePath: voiceMap['filePath'],
              duration: voiceMap['duration'],
              hash: voiceMap['hash'],
            );
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Remove a voice entry from a journal entry
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [voiceHash] The hash of the voice to remove
  Future<void> removeVoice(String journalEntryId, String voiceHash) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(journalEntryId);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(journalEntryId);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Get the existing voice entries
          if (existingData.containsKey('voiceEntries')) {
            List<Map<String, dynamic>> voiceEntries = (existingData['voiceEntries'] as List<dynamic>?)
                    ?.map((e) => Map<String, dynamic>.from(e as Map))
                    .toList() ??
                [];

            // Remove the voice with the matching hash
            voiceEntries.removeWhere((voice) => voice['hash'] == voiceHash);

            // Update the voice entries in the existing data
            existingData['voiceEntries'] = voiceEntries;
            existingData['updatedAt'] = DateTime.now().toIso8601String();

            // Set all data at once
            mutableDoc.setData(existingData);

            // Save the document
            await collection.saveDocument(mutableDoc);
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to remove voice: $e');
    }
  }

  /// Link a voice to a question-answer pair
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [questionAnswerPairId] The ID of the question-answer pair
  /// [voiceId] The ID of the voice to link
  Future<void> linkVoiceToQuestionAnswerPair(String journalEntryId, String questionAnswerPairId, String voiceId) async {
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
              // Get the voice entry IDs or create an empty list
              List<String> voiceEntryIds = List<String>.from(questions[questionIndex]['voiceEntryIds'] ?? []);

              // Add the voice ID if it doesn't already exist
              if (!voiceEntryIds.contains(voiceId)) {
                voiceEntryIds.add(voiceId);

                // Update the question-answer pair
                questions[questionIndex]['voiceEntryIds'] = voiceEntryIds;

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
      throw Exception('Failed to link voice: $e');
    }
  }

  /// Unlink a voice from a question-answer pair
  ///
  /// [journalEntryId] The ID of the journal entry
  /// [questionAnswerPairId] The ID of the question-answer pair
  /// [voiceId] The ID of the voice to unlink
  Future<void> unlinkVoiceFromQuestionAnswerPair(
      String journalEntryId, String questionAnswerPairId, String voiceId) async {
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
            if (questionIndex != -1 && questions[questionIndex].containsKey('voiceEntryIds')) {
              // Get the voice entry IDs
              List<String> voiceEntryIds = List<String>.from(questions[questionIndex]['voiceEntryIds'] ?? []);

              // Remove the voice ID
              voiceEntryIds.removeWhere((id) => id == voiceId);

              // Update the question-answer pair
              questions[questionIndex]['voiceEntryIds'] = voiceEntryIds;

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
      throw Exception('Failed to unlink voice: $e');
    }
  }
}
