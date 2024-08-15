// lib/infrastructure/repositories/mood_log_repository.dart
// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/list/state.dart';
// import 'package:teja/infrastructure/managers/mood_badge_manager.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';
// import 'package:teja/infrastructure/repositories/badge_repository.dart';

class MoodLogRepository {
  final Isar isar;

  MoodLogRepository(this.isar);
  static const String LAST_SYNC_KEY = 'last_mood_sync_timestamp';
  static const String FAILED_CHUNKS_KEY = 'failed_mood_chunks';

  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_SYNC_KEY, timestamp.toIso8601String());
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestampString = prefs.getString(LAST_SYNC_KEY);
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }

  Future<List<String>?> getPreviousFailedChunks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(FAILED_CHUNKS_KEY);
  }

  Future<void> storeFailedChunks(List<String> failedChunks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(FAILED_CHUNKS_KEY, failedChunks);
  }

  Future<void> clearFailedChunks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(FAILED_CHUNKS_KEY);
  }

  Future<void> addOrUpdateMoodLogs(List<MoodLogEntity> moodLogs) async {
    await isar.writeTxn(() async {
      for (var moodLogEntity in moodLogs) {
        final moodLog = MoodLog()
          ..id = moodLogEntity.id
          ..timestamp = moodLogEntity.timestamp
          ..moodRating = moodLogEntity.moodRating
          ..comment = moodLogEntity.comment
          ..feelings = moodLogEntity.feelings
              ?.map((f) => MoodLogFeeling()
                ..feeling = f.feeling
                ..comment = f.comment
                ..factors = f.factors
                ..detailed = f.detailed)
              .toList()
          ..factors = moodLogEntity.factors?.toList()
          ..attachments = moodLogEntity.attachments
              ?.map((a) => MoodLogAttachment()
                ..id = a.id
                ..type = a.type
                ..path = a.path)
              .toList()
          ..ai = moodLogEntity.ai != null
              ? (MoodLogAI()
                ..suggestion = moodLogEntity.ai!.suggestion
                ..title = moodLogEntity.ai!.title
                ..affirmation = moodLogEntity.ai!.affirmation)
              : null
          ..isDeleted = moodLogEntity.isDeleted
          ..updatedAt = DateTime.now();

        // Check if a mood log with this ID already exists
        final existingMoodLog = await isar.moodLogs.getById(moodLog.id);

        if (existingMoodLog != null) {
          // If it exists, update it only if the new entry is more recent
          if (moodLog.updatedAt.isAfter(existingMoodLog.updatedAt)) {
            moodLog.isarId = existingMoodLog.isarId; // Preserve the Isar ID
            await isar.moodLogs.put(moodLog);
          }
        } else {
          // If it doesn't exist, add it as a new entry
          await isar.moodLogs.put(moodLog);
        }
      }
    });
  }

  Future<void> softDeleteMoodLog(String id) async {
    await isar.writeTxn(() async {
      final moodLog = await isar.moodLogs.filter().idEqualTo(id).findFirst();
      if (moodLog != null) {
        moodLog.isDeleted = true;
        moodLog.updatedAt = DateTime.now();
        await isar.moodLogs.put(moodLog);
      }
    });
  }

  Future<MoodLog?> getMoodLogById(String? id) async {
    return isar.moodLogs.getById(id!);
  }

  Future<List<MoodLogEntity>> getAllMoodLogs({bool includeDeleted = false}) async {
    final query = isar.moodLogs.where();
    if (!includeDeleted) {
      query.filter().isDeletedEqualTo(false);
    }
    List<MoodLog> moodLogEntries = await query.findAll();
    return moodLogEntries.map((entry) => toEntity(entry)).toList();
  }

  Future<List> getMoodLogsPage(int pageKey, int pageSize, [MoodLogFilter? filter]) async {
    final startIndex = pageKey * pageSize;

    var filterConditions = <FilterCondition>[];

    // Add filter conditions based on selected mood ratings
    if (filter != null && filter.selectedMoodRatings.isNotEmpty) {
      for (var rating in filter.selectedMoodRatings) {
        filterConditions.add(FilterCondition.equalTo(
          property: 'moodRating',
          value: rating,
        ));
      }
    }

    final query = isar.moodLogs.buildQuery(
      filter: FilterGroup.or(filterConditions),
      sortBy: [const SortProperty(property: 'timestamp', sort: Sort.desc)],
      offset: startIndex,
      limit: pageSize,
    );

    final moodLogs = await query.findAll();

    return moodLogs.map((moodLog) => toEntity(moodLog)).toList();
  }

  Future<void> addAttachmentToMoodLog(String moodLogId, MoodLogAttachmentEntity attachmentEntity) async {
    await isar.writeTxn(() async {
      final moodLog = await isar.moodLogs.filter().idEqualTo(moodLogId).findFirst();
      if (moodLog != null) {
        final attachment = MoodLogAttachment()
          ..id = attachmentEntity.id
          ..type = attachmentEntity.type
          ..path = attachmentEntity.path;

        final attachments = List<MoodLogAttachment>.from(moodLog.attachments ?? [])..add(attachment);
        moodLog.attachments = attachments;
        await isar.moodLogs.put(moodLog);
      }
    });
  }

  Future<void> removeAttachmentFromMoodLog(String moodLogId, String attachmentId) async {
    await isar.writeTxn(() async {
      final moodLog = await isar.moodLogs.filter().idEqualTo(moodLogId).findFirst();
      if (moodLog != null && moodLog.attachments != null) {
        // Create a new list that excludes the attachment to be removed
        List<MoodLogAttachment> updatedAttachments =
            moodLog.attachments!.where((attachment) => attachment.id != attachmentId).toList();

        // Update the mood log with the new list of attachments
        moodLog.attachments = updatedAttachments;
        await isar.moodLogs.put(moodLog);

        // Optionally, handle file deletion here if needed
        // Assuming you have a method to safely delete the file
        try {
          final fileToDelete = File(attachmentId); // Ensure this path is correct
          if (await fileToDelete.exists()) {
            await fileToDelete.delete();
          }
        } catch (e) {}
      } else {}
    });
  }

  Future<void> updateMoodLogComment(String moodLogId, String comment) async {
    await isar.writeTxn(() async {
      MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
      if (moodLog != null) {
        moodLog.comment = comment;
        await isar.moodLogs.put(moodLog);
      }
    });
  }

  Future<List<MoodLogEntity>> getMoodLogsForWeek(DateTime startDate, DateTime endDate) async {
    // Fetch mood logs between startDate and endDate
    final moodLogs = await isar.moodLogs.filter().timestampBetween(startDate, endDate).findAll();
    // Convert MoodLog to MoodLogEntity
    return moodLogs.map(toEntity).toList();
  }

  Future<Map<DateTime, double>> getAverageMoodLogsForWeek(DateTime startDate, DateTime endDate) async {
    final moodLogs = await isar.moodLogs.filter().timestampBetween(startDate, endDate).findAll();

    Map<DateTime, List<int>> dailyRatings = {};
    for (var log in moodLogs) {
      DateTime day = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      dailyRatings.putIfAbsent(day, () => []).add(log.moodRating);
    }

    Map<DateTime, double> averageRatings = {};
    dailyRatings.forEach((date, ratings) {
      averageRatings[date] = ratings.reduce((a, b) => a + b) / ratings.length;
    });

    return averageRatings;
  }

  Future<void> addOrUpdateMoodLog(MoodLog moodLog) async {
    await isar.writeTxn(() async {
      moodLog.updatedAt = DateTime.now();
      await isar.moodLogs.put(moodLog);
    });
  }

  Future<void> deleteMoodLogById(String? id) async {
    // Use the isarId to delete the mood log.
    await isar.writeTxn(() async {
      await isar.moodLogs.deleteById(id!);
    });
  }

  Future<void> updateFeelingsForMoodLog(
    String moodLogId,
    List<MoodLogFeeling> updatedFeelings,
  ) async {
    final MoodLog? moodLog = await getMoodLogById(moodLogId);
    if (moodLog != null) {
      moodLog.feelings = updatedFeelings.cast<MoodLogFeeling>(); // Update the embedded feelings
      await addOrUpdateMoodLog(moodLog);
    }
  }

  Future<void> updateBroadFactorsForMoodLog(String moodLogId, List<String> broadFactors) async {
    await isar.writeTxn(() async {
      MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
      if (moodLog != null) {
        moodLog.factors = broadFactors; // Update the broad factors field
        moodLog.updatedAt = DateTime.now();
        await isar.moodLogs.put(moodLog);
      } else {}
    });
  }

  Future<void> updateFactorsForFeeling(String moodLogId, String feelingSlug, List<String>? factorSlugs) async {
    final MoodLog? moodLog = await getMoodLogById(moodLogId);
    if (moodLog != null && moodLog.feelings != null) {
      // Create a new list for updated feelings
      List<MoodLogFeeling> updatedFeelings = moodLog.feelings!.map((feeling) {
        if (feeling.feeling == feelingSlug) {
          // For the matching feeling, create a new instance with updated factors
          return MoodLogFeeling()
            ..feeling = feeling.feeling
            ..comment = feeling.comment
            ..factors = factorSlugs;
        } else {
          // For non-matching feelings, create a new instance with existing data
          return MoodLogFeeling()
            ..feeling = feeling.feeling
            ..comment = feeling.comment
            ..factors = feeling.factors;
        }
      }).toList(growable: true);

      moodLog.feelings = updatedFeelings;
      await addOrUpdateMoodLog(moodLog);
    } else {}
  }

  Future<MoodLog?> getTodaysMoodLog() async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final moodLogs = await isar.moodLogs.filter().timestampBetween(startOfDay, endOfDay).findAll();

    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }

  Future<List<MoodLog>> getMoodLogsInDateRange(DateTime start, DateTime end) async {
    try {
      final List<MoodLog> logs = await isar.moodLogs.filter().timestampBetween(start, end).findAll();
      return logs;
    } catch (e) {
      rethrow; // To ensure the error is propagated
    }
  }

  Future<MoodLog?> getMoodLogByDate(DateTime date) async {
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final moodLogs = await isar.moodLogs.filter().timestampBetween(startOfDay, endOfDay).findAll();

    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }

  Future<int> calculateCurrentStreak() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    int streakCount = 0;
    DateTime? currentDay = today;

    while (true) {
      final MoodLog? moodLog = await getMoodLogByDate(currentDay!);
      if (moodLog != null) {
        streakCount++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streakCount;
  }

  MoodLogEntity toEntity(MoodLog moodLog) {
    return MoodLogEntity(
      id: moodLog.id,
      timestamp: moodLog.timestamp,
      moodRating: moodLog.moodRating,
      comment: moodLog.comment,
      feelings: moodLog.feelings
          ?.map((f) => FeelingEntity(
                feeling: f.feeling ?? '',
                comment: f.comment,
                factors: f.factors,
                detailed: f.detailed,
              ))
          .toList(),
      factors: moodLog.factors?.toList(),
      attachments: moodLog.attachments
          ?.map((a) => MoodLogAttachmentEntity(
                id: a.id,
                type: a.type,
                path: a.path,
              ))
          .toList(),
      ai: moodLog.ai != null
          ? MoodLogAIEntity(
              suggestion: moodLog.ai!.suggestion,
              title: moodLog.ai!.title,
              affirmation: moodLog.ai!.affirmation,
            )
          : null,
      isDeleted: moodLog.isDeleted,
      createdAt: moodLog.createdAt,
      updatedAt: moodLog.updatedAt,
    );
  }

  Future<void> updateAISuggestion(String moodLogId, String suggestion) async {
    await isar.writeTxn(() async {
      MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
      if (moodLog != null) {
        moodLog.ai = MoodLogAI()..suggestion = suggestion;
        await isar.moodLogs.put(moodLog);
      }
    });
  }

  Future<String?> fetchAISuggestion(String moodLogId) async {
    MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
    return moodLog?.ai?.suggestion;
  }

  // Add these methods to the repository

  Future<void> updateAITitle(String moodLogId, String title) async {
    await isar.writeTxn(() async {
      MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
      if (moodLog != null) {
        moodLog.ai = (moodLog.ai ?? MoodLogAI())..title = title;
        await isar.moodLogs.put(moodLog);
      }
    });
  }

  Future<void> updateAIAffirmation(String moodLogId, String affirmation) async {
    await isar.writeTxn(() async {
      MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
      if (moodLog != null) {
        moodLog.ai = (moodLog.ai ?? MoodLogAI())..affirmation = affirmation;
        await isar.moodLogs.put(moodLog);
      }
    });
  }

  Future<String?> fetchAITitle(String moodLogId) async {
    MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
    return moodLog?.ai?.title;
  }

  Future<String?> fetchAIAffirmation(String moodLogId) async {
    MoodLog? moodLog = await isar.moodLogs.where().idEqualTo(moodLogId).findFirst();
    return moodLog?.ai?.affirmation;
  }
}
