import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/task.dart';

class TaskRepository {
  final Isar isar;

  TaskRepository(this.isar);

  static const String LAST_SYNC_KEY = 'last_task_sync_timestamp';
  static const String FAILED_CHUNKS_KEY = 'failed_task_chunks';

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

  Future<List<TaskEntity>> getAllTasks({bool includeDeleted = false}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final query = isar.tasks.where();
    if (!includeDeleted) {
      query.filter().isDeletedEqualTo(false);
    }

    final tasks = await query.findAll();
    return tasks
        .where((task) {
          final taskEntity = TaskEntity.fromIsar(task);

          switch (taskEntity.type) {
            case TaskType.todo:
              print("taskEntity.completedAt ${taskEntity.completedAt}");
              // Show todos if they're not completed or completed today
              return taskEntity.completedAt == null ||
                  taskEntity.completedAt!
                      .isAfter(today.subtract(Duration(days: 1)));
            case TaskType.daily:
              // Show dailies if they're not completed today
              return true;
            case TaskType.habit:
              // Always show habits
              return true;
          }
        })
        .map((task) => TaskEntity.fromIsar(task))
        .toList();
  }

  Future<void> addOrUpdateTasks(List<TaskEntity> tasks) async {
    await isar.writeTxn(() async {
      for (var taskEntity in tasks) {
        final task = taskEntity.toIsar();
        task.updatedAt = DateTime.now();
        await isar.tasks.put(task);
      }
    });
  }

  Future<void> addTask(TaskEntity task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task.toIsar());
    });
  }

  Future<void> updateTask(TaskEntity task) async {
    await isar.writeTxn(() async {
      final existingTask =
          await isar.tasks.filter().taskIdEqualTo(task.id).findFirst();
      if (existingTask != null) {
        // Convert existing Isar task to TaskEntity
        final existingTaskEntity = TaskEntity.fromIsar(existingTask);
        // Create a map of existing notes using noteId as the key
        final existingNotes = {
          for (var note in existingTaskEntity.notes ?? []) note.id: note
        };

        final updatedNotes = <TaskNoteEntity>[];

        // Update existing notes and add new ones
        for (var newNote in task.notes ?? []) {
          if (existingNotes.containsKey(newNote.id)) {
            // Update existing note
            updatedNotes.add(existingNotes[newNote.id]!.copyWith(
              content: newNote.content,
              // Add other fields if they can be updated
            ));
          } else {
            // Add new note
            updatedNotes.add(newNote);
          }
        }

        // Create updated TaskEntity
        final updatedTaskEntity = existingTaskEntity.copyWith(
          title: task.title,
          description: task.description,
          notes: updatedNotes,
          due: task.due,
          labels: task.labels,
          priority: task.priority,
          duration: task.duration,
          pomodoros: task.pomodoros,
          type: task.type,
          habitDirection: task.habitDirection,
          daysOfWeek: task.daysOfWeek,
          completedAt: task.completedAt,
          completedDates: task.completedDates,
          habitEntries: task.habitEntries,
          updatedAt: DateTime.now(),
        );

        // Convert updated TaskEntity back to Isar Task and save
        await isar.tasks.put(updatedTaskEntity.toIsar());
      } else {
        // If task doesn't exist, simply add the new task
        await isar.tasks.put(task.toIsar());
      }
    });
  }

  Future<void> deleteTask(String taskId) async {
    await isar.writeTxn(() async {
      await isar.tasks.filter().taskIdEqualTo(taskId).deleteAll();
    });
  }

  Future<void> softDeleteTask(String taskId) async {
    await isar.writeTxn(() async {
      final task = await isar.tasks.filter().taskIdEqualTo(taskId).findFirst();
      if (task != null) {
        task.isDeleted = true;
        task.updatedAt = DateTime.now();
        await isar.tasks.put(task);
      }
    });
  }

  Future<TaskEntity> toggleTaskCompletion(String taskId) async {
    late TaskEntity updatedTaskEntity;
    await isar.writeTxn(() async {
      final task = await isar.tasks.filter().taskIdEqualTo(taskId).findFirst();
      if (task != null) {
        final taskEntity = TaskEntity.fromIsar(task);
        updatedTaskEntity = _toggleCompletion(taskEntity);
        Task updatedTask = updatedTaskEntity.toIsar();
        updatedTask.updatedAt = DateTime.now();
        await isar.tasks.put(updatedTask);
      } else {
        throw Exception('Task not found');
      }
    });
    return updatedTaskEntity;
  }

  Future<void> incrementHabit(String taskId, HabitDirection direction) async {
    await isar.writeTxn(() async {
      final task = await isar.tasks.filter().taskIdEqualTo(taskId).findFirst();
      if (task != null) {
        final taskEntity = TaskEntity.fromIsar(task);
        final updatedTaskEntity = _incrementHabit(taskEntity, direction);
        Task updatedTask = updatedTaskEntity.toIsar();
        updatedTask.updatedAt = DateTime.now();
        await isar.tasks.put(updatedTask);
      }
    });
  }

  TaskEntity _toggleCompletion(TaskEntity taskEntity) {
    switch (taskEntity.type) {
      case TaskType.todo:
        final newCompletedAt =
            taskEntity.completedAt == null ? DateTime.now() : null;
        return taskEntity.copyWith(completedAt: newCompletedAt);
      case TaskType.daily:
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        List<DateTime> updatedCompletedDates =
            List.from(taskEntity.completedDates);
        if (updatedCompletedDates.contains(todayDate)) {
          updatedCompletedDates.remove(todayDate);
        } else {
          updatedCompletedDates.add(todayDate);
        }
        return taskEntity.copyWith(completedDates: updatedCompletedDates);
      case TaskType.habit:
        // Habits are not toggled
        return taskEntity;
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
