// lib/infrastructure/repositories/mood_log_repository.dart
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/list/state.dart';
// import 'package:teja/infrastructure/managers/mood_badge_manager.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';
// import 'package:teja/infrastructure/repositories/badge_repository.dart';

class MoodLogRepository {
  final Isar isar;

  MoodLogRepository(this.isar);

  Future<MoodLog?> getMoodLogById(String? id) async {
    return isar.moodLogs.getById(id!);
  }

  Future<List<MoodLog>> getAllMoodLogs() async {
    return isar.moodLogs.where().findAll();
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
        } catch (e) {
          print("Error deleting file: $e");
        }
      } else {
        print("Mood log with ID $moodLogId not found or has no attachments.");
      }
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
        await isar.moodLogs.put(moodLog);
      } else {
        print("Mood log with ID $moodLogId not found.");
      }
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
    } else {
      print("Mood log with ID $moodLogId not found.");
    }
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
    List<MoodLogAttachmentEntity>? attachments = moodLog.attachments
        ?.map((attachment) => MoodLogAttachmentEntity(
              id: attachment.id,
              type: attachment.type,
              path: attachment.path,
            ))
        .toList();

    MoodLogAIEntity? ai = moodLog.ai != null
        ? MoodLogAIEntity(
            suggestion: moodLog.ai!.suggestion,
          )
        : null;

    return MoodLogEntity(
      id: moodLog.id,
      timestamp: moodLog.timestamp,
      moodRating: moodLog.moodRating,
      comment: moodLog.comment,
      feelings: moodLog.feelings
          ?.map((feeling) => FeelingEntity(
                feeling: feeling.feeling ?? '',
                comment: feeling.comment,
                factors: feeling.factors,
                detailed: feeling.detailed,
              ))
          .toList(),
      factors: moodLog.factors,
      attachments: attachments,
      ai: ai, // Add the AI suggestion entity
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
}
