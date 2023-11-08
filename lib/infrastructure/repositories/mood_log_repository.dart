// lib/infrastructure/repositories/mood_log_repository.dart
import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';

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
}
