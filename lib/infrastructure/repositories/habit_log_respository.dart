import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/database/isar_collections/habit_log.dart';

class HabitLogRepository {
  final Isar isar;

  HabitLogRepository(this.isar);

  Future<List<HabitLog>> getAllHabitLogs() async {
    return isar.habitLogs.where().findAll();
  }

  Future<List<HabitLog>> getLogsForHabit(String habitId) async {
    return isar.habitLogs.where().idEqualTo(habitId).findAll();
  }

  Future<void> addHabitLog(HabitLog habitLog) async {
    await isar.writeTxn(() async {
      await isar.habitLogs.put(habitLog);
    });
  }

  Future<void> updateHabitLog(HabitLog habitLog) async {
    await isar.writeTxn(() async {
      await isar.habitLogs.put(habitLog);
    });
  }

  Future<void> deleteHabitLog(String id) async {
    await isar.writeTxn(() async {
      final habitLog = await isar.habitLogs.where().idEqualTo(id).findFirst();
      if (habitLog != null) {
        await isar.habitLogs.delete(habitLog.isarId);
      }
    });
  }
}
