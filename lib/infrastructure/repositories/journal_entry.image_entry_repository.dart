import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

class ImageEntryRepository {
  final Isar isar;

  ImageEntryRepository(this.isar);

  Future<void> addOrUpdateImage(String journalEntryId, ImageEntry newImage) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId); // Use get instead of getById
      if (entry != null) {
        var images = entry.imageEntries ?? [];
        var existingIndex = images.indexWhere((img) => img.hash == newImage.hash);
        if (existingIndex == -1) {
          images = List.from(images)..add(newImage);
        }
        entry.imageEntries = images;
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<ImageEntry?> findImageByHash(String journalEntryId, String hash) async {
    var entry = await isar.journalEntrys.getById(journalEntryId);
    if (entry != null && entry.imageEntries != null) {
      return entry.imageEntries!.firstWhereOrNull((image) => image.hash == hash);
    }
    return null;
  }

  Future<void> removeImage(String journalEntryId, String imageHash) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId); // Use get for consistency
      if (entry?.imageEntries != null) {
        entry!.imageEntries!.removeWhere((img) => img.hash == imageHash);
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<void> linkImageToQuestionAnswerPair(String journalEntryId, String questionAnswerPairId, String imageId) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var questionAnswerPair = entry.questions?.firstWhereOrNull((q) => q.id == questionAnswerPairId);
        if (questionAnswerPair != null) {
          var imageEntryIds = List<String>.from(questionAnswerPair.imageEntryIds ?? []); // Ensure a mutable list
          if (!imageEntryIds.contains(imageId)) {
            imageEntryIds.add(imageId);
            questionAnswerPair.imageEntryIds = imageEntryIds; // Reassign the modified list back to the entity
            await isar.journalEntrys.put(entry); // Save the modified entry back to the database
          }
        }
      }
    });
  }

  Future<void> unlinkImageFromQuestionAnswerPair(
      String journalEntryId, String questionAnswerPairId, String imageId) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var questionAnswerPair = entry.questions?.firstWhereOrNull((q) => q.id == questionAnswerPairId);
        if (questionAnswerPair != null && questionAnswerPair.imageEntryIds != null) {
          questionAnswerPair.imageEntryIds!.removeWhere((id) => id == imageId);
          await isar.journalEntrys.put(entry);
        }
      }
    });
  }
}
