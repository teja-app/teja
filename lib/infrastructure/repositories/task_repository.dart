// File: lib/infrastructure/repositories/task_repository.dart

import 'package:isar/isar.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/task.dart';

class TaskRepository {
  final Isar isar;

  TaskRepository(this.isar);

  Future<List<TaskEntity>> getAllTasks() async {
    final tasks = await isar.tasks.where().findAll();
    return tasks.map((task) => TaskEntity.fromIsar(task)).toList();
  }

  Future<void> addTask(TaskEntity task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task.toIsar());
    });
  }

  Future<void> updateTask(TaskEntity task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task.toIsar());
    });
  }

  Future<void> deleteTask(String taskId) async {
    await isar.writeTxn(() async {
      await isar.tasks.filter().taskIdEqualTo(taskId).deleteAll();
    });
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    await isar.writeTxn(() async {
      final task = await isar.tasks.filter().taskIdEqualTo(taskId).findFirst();
      if (task != null) {
        final taskEntity = TaskEntity.fromIsar(task);
        final updatedTaskEntity = _toggleCompletion(taskEntity);
        await isar.tasks.put(updatedTaskEntity.toIsar());
      }
    });
  }

  Future<void> incrementHabit(String taskId, HabitDirection direction) async {
    await isar.writeTxn(() async {
      final task = await isar.tasks.filter().taskIdEqualTo(taskId).findFirst();
      if (task != null) {
        final taskEntity = TaskEntity.fromIsar(task);
        final updatedTaskEntity = _incrementHabit(taskEntity, direction);
        await isar.tasks.put(updatedTaskEntity.toIsar());
      }
    });
  }

  TaskEntity _toggleCompletion(TaskEntity task) {
    switch (task.type) {
      case TaskType.todo:
        return task.copyWith(completedAt: task.completedAt == null ? DateTime.now() : null);
      case TaskType.daily:
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        List<DateTime> updatedCompletedDates = List.from(task.completedDates);
        if (updatedCompletedDates.contains(todayDate)) {
          updatedCompletedDates.remove(todayDate);
        } else {
          updatedCompletedDates.add(todayDate);
        }
        return task.copyWith(completedDates: updatedCompletedDates);
      case TaskType.habit:
        // Habits are not toggled
        return task;
    }
  }

  TaskEntity _incrementHabit(TaskEntity task, HabitDirection direction) {
    if (task.type == TaskType.habit) {
      List<HabitEntryEntity> updatedEntries = List.from(task.habitEntries)
        ..add(HabitEntryEntity(
          timestamp: DateTime.now(),
          direction: direction,
        ));
      return task.copyWith(habitEntries: updatedEntries);
    }
    return task;
  }
}
