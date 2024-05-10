import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';

class VideoEntryRepository {
  final Isar isar;

  VideoEntryRepository(this.isar);

  Future<void> addOrUpdateVideo(String journalEntryId, VideoEntry newVideo) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var videos = entry.videoEntries ?? [];
        var existingIndex = videos.indexWhere((vid) => vid.hash == newVideo.hash);
        if (existingIndex == -1) {
          videos = List.from(videos)..add(newVideo);
        }
        entry.videoEntries = videos;
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<VideoEntry?> findVideoByHash(String journalEntryId, String hash) async {
    var entry = await isar.journalEntrys.getById(journalEntryId);
    if (entry != null && entry.videoEntries != null) {
      return entry.videoEntries!.firstWhereOrNull((video) => video.hash == hash);
    }
    return null;
  }

  Future<void> removeVideo(String journalEntryId, String videoHash) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry?.videoEntries != null) {
        entry!.videoEntries!.removeWhere((vid) => vid.hash == videoHash);
        await isar.journalEntrys.put(entry);
      }
    });
  }

  Future<void> linkVideoToQuestionAnswerPair(String journalEntryId, String questionAnswerPairId, String videoId) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var questionAnswerPair = entry.questions?.firstWhereOrNull((q) => q.id == questionAnswerPairId);
        if (questionAnswerPair != null) {
          var videoEntryIds = List<String>.from(questionAnswerPair.videoEntryIds ?? []);
          if (!videoEntryIds.contains(videoId)) {
            videoEntryIds.add(videoId);
            questionAnswerPair.videoEntryIds = videoEntryIds;
            await isar.journalEntrys.put(entry);
          }
        }
      }
    });
  }

  Future<void> unlinkVideoFromQuestionAnswerPair(
      String journalEntryId, String questionAnswerPairId, String videoId) async {
    await isar.writeTxn(() async {
      var entry = await isar.journalEntrys.getById(journalEntryId);
      if (entry != null) {
        var questionAnswerPair = entry.questions?.firstWhereOrNull((q) => q.id == questionAnswerPairId);
        if (questionAnswerPair != null && questionAnswerPair.videoEntryIds != null) {
          questionAnswerPair.videoEntryIds!.removeWhere((id) => id == videoId);
          await isar.journalEntrys.put(entry);
        }
      }
    });
  }
}
