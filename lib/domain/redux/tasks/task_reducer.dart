import 'package:redux/redux.dart';
import 'package:teja/domain/redux/tasks/task_action.dart';
import 'package:teja/domain/redux/tasks/task_state.dart';
import 'package:teja/domain/entities/task_entity.dart';

Reducer<TaskState> taskReducer = combineReducers<TaskState>([
  TypedReducer<TaskState, TaskUpdateInProgressAction>(_taskUpdateInProgress),
  TypedReducer<TaskState, TaskUpdateSuccessAction>(_taskUpdateSuccess),
  TypedReducer<TaskState, TaskUpdateFailedAction>(_taskUpdateFailed),
  TypedReducer<TaskState, AddTaskAction>(_addTask),
  TypedReducer<TaskState, UpdateTaskAction>(_updateTask),
  TypedReducer<TaskState, DeleteTaskAction>(_deleteTask),
  TypedReducer<TaskState, ToggleTaskCompletionAction>(_toggleTaskCompletion),
  TypedReducer<TaskState, IncrementHabitAction>(_incrementHabit),
]);

TaskState _taskUpdateInProgress(TaskState state, TaskUpdateInProgressAction action) {
  return state.copyWith(isLoading: true, errorMessage: null);
}

TaskState _taskUpdateSuccess(TaskState state, TaskUpdateSuccessAction action) {
  return state.copyWith(
    tasks: action.tasks,
    isLoading: false,
    errorMessage: null,
  );
}

TaskState _taskUpdateFailed(TaskState state, TaskUpdateFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.error,
  );
}

TaskState _addTask(TaskState state, AddTaskAction action) {
  List<TaskEntity> updatedTasks = List.from(state.tasks)..add(action.task);
  return state.copyWith(tasks: updatedTasks);
}

TaskState _updateTask(TaskState state, UpdateTaskAction action) {
  List<TaskEntity> updatedTasks = state.tasks.map((task) {
    return task.id == action.task.id ? action.task : task;
  }).toList();
  return state.copyWith(tasks: updatedTasks);
}

TaskState _deleteTask(TaskState state, DeleteTaskAction action) {
  List<TaskEntity> updatedTasks = state.tasks.where((task) => task.id != action.taskId).toList();
  return state.copyWith(tasks: updatedTasks);
}

TaskState _toggleTaskCompletion(TaskState state, ToggleTaskCompletionAction action) {
  List<TaskEntity> updatedTasks = state.tasks.map((task) {
    if (task.id == action.taskId) {
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
    return task;
  }).toList();
  return state.copyWith(tasks: updatedTasks);
}

TaskState _incrementHabit(TaskState state, IncrementHabitAction action) {
  List<TaskEntity> updatedTasks = state.tasks.map((task) {
    if (task.id == action.taskId && task.type == TaskType.habit) {
      List<HabitEntryEntity> updatedEntries = List.from(task.habitEntries)
        ..add(HabitEntryEntity(timestamp: DateTime.now(), direction: action.direction));
      return task.copyWith(habitEntries: updatedEntries);
    }
    return task;
  }).toList();
  return state.copyWith(tasks: updatedTasks);
}
