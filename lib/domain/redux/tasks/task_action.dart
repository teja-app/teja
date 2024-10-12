import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/task_entity.dart';

@immutable
class LoadTasksAction {}

@immutable
class TasksLoadedAction {
  final List<TaskEntity> tasks;

  const TasksLoadedAction(this.tasks);
}

@immutable
class AddTaskAction {
  final TaskEntity task;

  const AddTaskAction(this.task);
}

@immutable
class UpdateTaskAction {
  final TaskEntity task;

  const UpdateTaskAction(this.task);
}

@immutable
class DeleteTaskAction {
  final String taskId;

  const DeleteTaskAction(this.taskId);
}

@immutable
class ToggleTaskCompletionAction {
  final String taskId;

  const ToggleTaskCompletionAction(this.taskId);
}

@immutable
class IncrementHabitAction {
  final String taskId;
  final HabitDirection direction;

  const IncrementHabitAction(this.taskId, this.direction);
}

@immutable
class SyncTasksAction {}

@immutable
class SyncTasksSuccessAction {
  final List<TaskEntity> updatedTasks;

  const SyncTasksSuccessAction(this.updatedTasks);
}

@immutable
class SyncTasksFailureAction {
  final String error;

  const SyncTasksFailureAction(this.error);
}

@immutable
class TaskUpdateInProgressAction {}

@immutable
class TaskUpdateSuccessAction {
  final List<TaskEntity> tasks;

  const TaskUpdateSuccessAction(this.tasks);
}

@immutable
class TaskUpdateFailedAction {
  final String error;

  const TaskUpdateFailedAction(this.error);
}

@immutable
class ToggleShowAllTasksAction {}

@immutable
class ToggleExpandedSectionAction {
  final TaskType taskType;

  const ToggleExpandedSectionAction(this.taskType);
}

@immutable
class FetchInitialTasksAction {
  const FetchInitialTasksAction();
}

@immutable
class FetchInitialTasksSuccessAction {
  final List<TaskEntity> tasks;

  const FetchInitialTasksSuccessAction(this.tasks);
}

@immutable
class FetchInitialTasksFailureAction {
  final String error;

  const FetchInitialTasksFailureAction(this.error);
}

@immutable
class ResetTasksAction {
  const ResetTasksAction();
}
