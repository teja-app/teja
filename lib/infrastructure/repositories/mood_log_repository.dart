// lib/infrastructure/repositories/mood_log_repository.dart
import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log_feeling.dart';

class MoodLogRepository {
  final Isar isar;

  MoodLogRepository(this.isar);

  Future<MoodLog?> getMoodLogById(int id) async {
    // Directly use the isarId to find the mood log.
    return isar.moodLogs.get(id);
  }

  Future<List<MoodLog>> getAllMoodLogs() async {
    return isar.moodLogs.where().findAll();
  }

  Future<void> addOrUpdateMoodLog(MoodLog moodLog) async {
    await isar.writeTxn(() async {
      await isar.moodLogs.put(moodLog);
    });
  }

  Future<void> deleteMoodLogById(int id) async {
    // Use the isarId to delete the mood log.
    await isar.writeTxn(() async {
      await isar.moodLogs.delete(id);
    });
  }

  Future<void> getFeelingsForMoodLog(int moodLogId) async {
    final moodLog = await getMoodLogById(moodLogId);
    if (moodLog != null) {
      // Load and return the feelings associated with the mood log.
      return moodLog.feelings.load();
    }
  }

  Future<void> addFeelingToMoodLog(
      int moodLogId, MoodLogFeeling feeling) async {
    final moodLog = await getMoodLogById(moodLogId);
    if (moodLog != null) {
      // Assuming moodLogFeelings is a link set to the feelings, add a new feeling to it.
      await isar.writeTxn(() async {
        moodLog.feelings.add(feeling);
      });
    }
  }

  Future<MoodLog?> getTodaysMoodLog() async {
    print("getTodaysMoodLog::Called");
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    final moodLogs = await isar.moodLogs
        .filter()
        .timestampBetween(startOfDay, endOfDay)
        .findAll();

    print("moodLogs:count ${moodLogs.length}");
    print("getTodaysMoodLog::moodLogs ${moodLogs.first.moodRating}");
    // Assuming you only record one mood per day, you can take the first result.
    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }
}
