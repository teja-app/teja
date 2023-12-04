import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/habit.dart';

class HabitRepository {
  final Isar isar;

  HabitRepository(this.isar);

  Future<List<Habit>> getAllHabits() async {
    return isar.habits.where().findAll();
  }

  Future<Habit?> getHabitById(String id) async {
    return isar.habits.where().idEqualTo(id).findFirst();
  }

  Future<void> addHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
  }

  Future<void> updateHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
  }

  Future<void> deleteHabit(String id) async {
    await isar.writeTxn(() async {
      final habit = await isar.habits.where().idEqualTo(id).findFirst();
      if (habit != null) {
        await isar.habits.delete(habit.isarId);
      }
    });
  }
}
