// lib/infrastructure/repositories/mood_log_repository.dart
import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/managers/mood_badge_manager.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';
import 'package:swayam/infrastructure/repositories/badge_repository.dart';

class MoodLogRepository {
  final Isar isar;

  MoodLogRepository(this.isar);

  Future<MoodLog?> getMoodLogById(String? id) async {
    return isar.moodLogs.getById(id!);
  }

  Future<List<MoodLog>> getAllMoodLogs() async {
    return isar.moodLogs.where().findAll();
  }

  Future<void> addOrUpdateMoodLog(MoodLog moodLog) async {
    await isar.writeTxn(() async {
      await isar.moodLogs.put(moodLog);
      // After updating the mood log, check the streak and assign badges.
      await calculateCurrentStreak();
      final criteria = await loadStreakBadgeCriteria();
      final moodBadgeManager =
          MoodBadgeManager(BadgeRepository(isar), this, criteria);
      await moodBadgeManager.evaluateAndAwardMoodBadges(inTransaction: true);
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
      moodLog.feelings = updatedFeelings
          .cast<MoodLogFeeling>(); // Update the embedded feelings
      await addOrUpdateMoodLog(moodLog); // Save the updated mood log
    }
  }

  Future<MoodLog?> getTodaysMoodLog() async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    final moodLogs = await isar.moodLogs
        .filter()
        .timestampBetween(startOfDay, endOfDay)
        .findAll();

    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }

  Future<List<MoodLog>> getMoodLogsInDateRange(
      DateTime start, DateTime end) async {
    try {
      final List<MoodLog> logs =
          await isar.moodLogs.filter().timestampBetween(start, end).findAll();
      return logs;
    } catch (e) {
      rethrow; // To ensure the error is propagated
    }
  }

  Future<MoodLog?> getMoodLogByDate(DateTime date) async {
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay =
        DateTime(date.year, date.month, date.day, 23, 59, 59);

    final moodLogs = await isar.moodLogs
        .filter()
        .timestampBetween(startOfDay, endOfDay)
        .findAll();

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
}
