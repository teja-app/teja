import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/domain/redux/tasks/task_action.dart';
import 'package:teja/infrastructure/repositories/task_repository.dart';
import 'package:teja/infrastructure/api/task_api.dart';

class TaskSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchTasksFromDatabase, pattern: LoadTasksAction);
    yield TakeEvery(_addTask, pattern: AddTaskAction);
    yield TakeEvery(_updateTask, pattern: UpdateTaskAction);
    yield TakeEvery(_deleteTask, pattern: DeleteTaskAction);
    yield TakeEvery(_toggleTaskCompletion, pattern: ToggleTaskCompletionAction);
    yield TakeEvery(_incrementHabit, pattern: IncrementHabitAction);
    yield TakeEvery(_syncTasks, pattern: SyncTasksAction);
    yield TakeEvery(_handleFetchInitialTasks, pattern: FetchInitialTasksAction);
  }

  _fetchTasksFromDatabase({dynamic action}) sync* {
    yield Put(TaskUpdateInProgressAction());

    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;
    var taskRepo = TaskRepository(isar);

    var tasksResult = Result<List<TaskEntity>>();
    yield Call(
      taskRepo.getAllTasks,
      result: tasksResult,
    );

    if (tasksResult.value != null) {
      yield Put(TaskUpdateSuccessAction(tasksResult.value!));
    } else {
      yield Put(const TaskUpdateFailedAction('Failed to load tasks'));
    }
  }

  _addTask({dynamic action}) sync* {
    if (action is AddTaskAction) {
      yield Try(() sync* {
        yield Put(TaskUpdateInProgressAction());

        var isarResult = Result<Isar>();
        yield GetContext('isar', result: isarResult);
        Isar isar = isarResult.value!;
        var taskRepo = TaskRepository(isar);

        var addResult = Result<void>();
        yield Call(
          taskRepo.addTask,
          args: [action.task],
          result: addResult,
        );

        yield Call(_fetchTasksFromDatabase);
        yield Put(SyncTasksAction());
      }, Catch: (e, s) sync* {
        yield Put(TaskUpdateFailedAction(e.toString()));
      });
    }
  }

  _updateTask({dynamic action}) sync* {
    if (action is UpdateTaskAction) {
      yield Try(() sync* {
        yield Put(TaskUpdateInProgressAction());

        var isarResult = Result<Isar>();
        yield GetContext('isar', result: isarResult);
        Isar isar = isarResult.value!;
        var taskRepo = TaskRepository(isar);

        var updateResult = Result<void>();
        yield Call(
          taskRepo.updateTask,
          args: [action.task],
          result: updateResult,
        );

        yield Call(_fetchTasksFromDatabase);
        yield Put(SyncTasksAction());
      }, Catch: (e, s) sync* {
        yield Put(TaskUpdateFailedAction(e.toString()));
      });
    }
  }

  _deleteTask({dynamic action}) sync* {
    if (action is DeleteTaskAction) {
      yield Try(() sync* {
        yield Put(TaskUpdateInProgressAction());

        var isarResult = Result<Isar>();
        yield GetContext('isar', result: isarResult);
        Isar isar = isarResult.value!;
        var taskRepo = TaskRepository(isar);

        var deleteResult = Result<void>();
        yield Call(
          taskRepo.softDeleteTask, // Change this to softDeleteTask
          args: [action.taskId],
          result: deleteResult,
        );

        yield Call(_fetchTasksFromDatabase);
        yield Put(SyncTasksAction());
      }, Catch: (e, s) sync* {
        yield Put(TaskUpdateFailedAction(e.toString()));
      });
    }
  }

  _toggleTaskCompletion({dynamic action}) sync* {
    if (action is ToggleTaskCompletionAction) {
      yield Try(() sync* {
        yield Put(TaskUpdateInProgressAction());

        var isarResult = Result<Isar>();
        yield GetContext('isar', result: isarResult);
        Isar isar = isarResult.value!;
        var taskRepo = TaskRepository(isar);

        var toggleResult = Result<TaskEntity?>();
        yield Call(
          taskRepo.toggleTaskCompletion,
          args: [action.taskId],
          result: toggleResult,
        );

        if (toggleResult.value != null) {
          yield Put(UpdateTaskAction(toggleResult.value!));
        }

        yield Call(_fetchTasksFromDatabase);
        yield Put(SyncTasksAction());
      }, Catch: (e, s) sync* {
        yield Put(TaskUpdateFailedAction(e.toString()));
      });
    }
  }

  _incrementHabit({dynamic action}) sync* {
    if (action is IncrementHabitAction) {
      yield Try(() sync* {
        yield Put(TaskUpdateInProgressAction());

        var isarResult = Result<Isar>();
        yield GetContext('isar', result: isarResult);
        Isar isar = isarResult.value!;
        var taskRepo = TaskRepository(isar);

        var incrementResult = Result<void>();
        yield Call(
          taskRepo.incrementHabit,
          args: [action.taskId, action.direction],
          result: incrementResult,
        );

        yield Call(_fetchTasksFromDatabase);
        yield Put(SyncTasksAction());
      }, Catch: (e, s) sync* {
        yield Put(TaskUpdateFailedAction(e.toString()));
      });
    }
  }

  _syncTasks({dynamic action}) sync* {
    yield Put(TaskUpdateInProgressAction());

    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;
    var taskRepo = TaskRepository(isar);

    var lastSyncTimestampResult = Result<DateTime?>();
    yield Call(taskRepo.getLastSyncTimestamp, result: lastSyncTimestampResult);
    DateTime lastSyncTimestamp =
        lastSyncTimestampResult.value ?? DateTime.fromMillisecondsSinceEpoch(0);

    var localTasksResult = Result<List<TaskEntity>>();
    yield Call(() => taskRepo.getAllTasks(includeDeleted: true),
        result: localTasksResult);
    List<TaskEntity> localTasks = localTasksResult.value!;

    var previousFailedChunksResult = Result<List<String>?>();
    yield Call(taskRepo.getPreviousFailedChunks,
        result: previousFailedChunksResult);
    List<String>? previousFailedChunks = previousFailedChunksResult.value;

    TaskApiService api = TaskApiService();

    var syncResultResult = Result<Map<String, dynamic>>();
    yield Call(
      api.syncTasks,
      args: [localTasks, lastSyncTimestamp, previousFailedChunks],
      result: syncResultResult,
    );
    var syncResult = syncResultResult.value!;

    if (syncResult['serverChanges'].isNotEmpty) {
      yield Call(taskRepo.addOrUpdateTasks,
          args: [syncResult['serverChanges']]);
    }

    if (syncResult['clientChanges'].isNotEmpty) {
      yield Call(taskRepo.addOrUpdateTasks,
          args: [syncResult['clientChanges']]);
    }

    // Update lastSyncTimestamp to the latest successfully synced task
    DateTime newSyncTimestamp =
        syncResult['lastSuccessfulSyncTimestamp'] ?? lastSyncTimestamp;
    yield Call(taskRepo.updateLastSyncTimestamp, args: [newSyncTimestamp]);

    if (syncResult['failedChunks'].isEmpty) {
      yield Call(taskRepo.clearFailedChunks);
      yield Put(SyncTasksSuccessAction(
          syncResult['serverChanges'] + syncResult['clientChanges']));
    } else {
      yield Call(taskRepo.storeFailedChunks,
          args: [syncResult['failedChunks']]);
      yield Put(SyncTasksFailureAction(
          'Sync partially failed. Some changes were not synced.'));
    }
    yield Call(_fetchTasksFromDatabase);
  }

  _handleFetchInitialTasks({required FetchInitialTasksAction action}) sync* {
    try {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var taskRepository = TaskRepository(isar);
      TaskApiService api = TaskApiService();

      // Fetch all tasks from the server
      var tasksResult = Result<List<TaskEntity>>();
      yield Call(api.getAllTasks,
          args: [], namedArgs: {#includeDeleted: true}, result: tasksResult);
      List<TaskEntity> tasks = tasksResult.value!;

      // Save all tasks to local storage
      yield Call(taskRepository.addOrUpdateTasks, args: [tasks]);

      // Update the last sync timestamp
      DateTime newSyncTimestamp = DateTime.now();
      yield Call(taskRepository.updateLastSyncTimestamp,
          args: [newSyncTimestamp]);

      yield Put(FetchInitialTasksSuccessAction(tasks));
    } catch (error) {
      yield Put(FetchInitialTasksFailureAction(error.toString()));
    }
  }
}
