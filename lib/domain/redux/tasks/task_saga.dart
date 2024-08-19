import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/domain/redux/tasks/task_action.dart';
import 'package:teja/infrastructure/repositories/task_repository.dart';

class TaskSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchTasksFromDatabase, pattern: LoadTasksAction);
    yield TakeEvery(_addTask, pattern: AddTaskAction);
    yield TakeEvery(_updateTask, pattern: UpdateTaskAction);
    yield TakeEvery(_deleteTask, pattern: DeleteTaskAction);
    yield TakeEvery(_toggleTaskCompletion, pattern: ToggleTaskCompletionAction);
    yield TakeEvery(_incrementHabit, pattern: IncrementHabitAction);
  }

  _fetchTasksFromDatabase({dynamic action}) sync* {
    yield Try(() sync* {
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
    }, Catch: (e, s) sync* {
      yield Put(TaskUpdateFailedAction(e.toString()));
    });
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
          taskRepo.deleteTask,
          args: [action.taskId],
          result: deleteResult,
        );

        yield Call(_fetchTasksFromDatabase);
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

        var toggleResult = Result<void>();
        yield Call(
          taskRepo.toggleTaskCompletion,
          args: [action.taskId],
          result: toggleResult,
        );

        yield Call(_fetchTasksFromDatabase);
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
      }, Catch: (e, s) sync* {
        yield Put(TaskUpdateFailedAction(e.toString()));
      });
    }
  }
}
