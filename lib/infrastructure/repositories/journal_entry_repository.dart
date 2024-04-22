import 'package:collection/collection.dart'; // Import collection package
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

class JournalEntryRepository {
  final Isar isar;

  JournalEntryRepository(this.isar);

  Future<JournalEntry?> getJournalEntryById(String? id) async {
    return isar.journalEntrys.getById(id!);
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    return isar.journalEntrys.where().findAll();
  }

  Future<void> addOrUpdateJournalEntry(JournalEntry journalEntry) async {
    await isar.writeTxn(() async {
      journalEntry.updatedAt = DateTime.now();
      await isar.journalEntrys.put(journalEntry);
    });
  }

  Future<void> deleteJournalEntryById(String? id) async {
    await isar.writeTxn(() async {
      await isar.journalEntrys.deleteById(id!);
    });
  }

  Future<List<JournalEntryEntity>> getJournalEntriesPage(int pageKey, int pageSize,
      {DateTime? startDate, DateTime? endDate}) async {
    final startIndex = pageKey * pageSize;

    var filterConditions = <FilterCondition>[];

    // Example filter condition based on a hypothetical date range
    if (startDate != null && endDate != null) {
      filterConditions.add(FilterCondition.between(
        property: 'timestamp',
        lower: startDate,
        upper: endDate,
      ));
    }

    final query = isar.journalEntrys.buildQuery(
      filter: filterConditions.isNotEmpty ? FilterGroup.and(filterConditions) : null,
      sortBy: [const SortProperty(property: 'timestamp', sort: Sort.desc)],
      offset: startIndex,
      limit: pageSize,
    );

    final journalEntries = await query.findAll();

    return journalEntries.map((moodLog) => toEntity(moodLog)).toList();
  }

  Future<List<JournalEntry>> getJournalEntriesInDateRange(DateTime start, DateTime end) async {
    try {
      // Fetch entries between the specified start and end dates
      final List<JournalEntry> entries = await isar.journalEntrys.filter().timestampBetween(start, end).findAll();

      return entries;
    } catch (e) {
      rethrow; // Propagate any errors for handling in the saga or higher-level logic
    }
  }

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

  JournalEntryEntity toEntity(JournalEntry journalEntry) {
    return JournalEntryEntity(
      id: journalEntry.id,
      templateId: journalEntry.templateId,
      timestamp: journalEntry.timestamp,
      createdAt: journalEntry.createdAt,
      updatedAt: journalEntry.updatedAt,
      questions: journalEntry.questions
          ?.map((q) => QuestionAnswerPairEntity(
                id: q.id,
                questionId: q.questionId,
                questionText: q.questionText,
                answerText: q.answerText,
                imageEntryIds: q.imageEntryIds,
                videoEntryIds: q.videoEntryIds,
                voiceEntryIds: q.voiceEntryIds,
              ))
          .toList(),
      textEntries: journalEntry.textEntries
          ?.map((t) => TextEntryEntity(
                id: t.id,
                content: t.content,
              ))
          .toList(),
      voiceEntries: journalEntry.voiceEntries
          ?.map((v) => VoiceEntryEntity(
                id: v.id,
                filePath: v.filePath,
                duration: v.duration,
                hash: v.hash,
              ))
          .toList(),
      videoEntries: journalEntry.videoEntries
          ?.map((v) => VideoEntryEntity(
                id: v.id,
                filePath: v.filePath,
                duration: v.duration,
                hash: v.hash,
              ))
          .toList(),
      imageEntries: journalEntry.imageEntries
          ?.map((i) => ImageEntryEntity(
                id: i.id,
                filePath: i.filePath,
                caption: i.caption,
                hash: i.hash,
              ))
          .toList(),
      bulletPointEntries: journalEntry.bulletPointEntries
          ?.map((b) => BulletPointEntryEntity(
                id: b.id,
                points: b.points,
              ))
          .toList(),
      painNoteEntries: journalEntry.painNoteEntries
          ?.map((p) => PainNoteEntryEntity(
                id: p.id,
                painLevel: p.painLevel,
                notes: p.notes,
              ))
          .toList(),
      metadata: journalEntry.metadata != null ? JournalEntryMetadataEntity(tags: journalEntry.metadata?.tags) : null,
    );
  }
}
