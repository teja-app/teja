import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/task_entity.dart';

@immutable
class TaskState {
  final List<TaskEntity> tasks;
  final bool isLoading;
  final String? errorMessage;
  final bool showAllTasks;
  final Map<TaskType, bool> expandedSections;

  const TaskState({
    required this.tasks,
    this.isLoading = false,
    this.errorMessage,
    this.showAllTasks = false,
    this.expandedSections = const {
      TaskType.todo: true,
      TaskType.daily: false,
      TaskType.habit: false,
    },
  });

  factory TaskState.initial() {
    return const TaskState(
      tasks: [],
      isLoading: false,
      errorMessage: null,
      showAllTasks: false,
      expandedSections: {
        TaskType.todo: true,
        TaskType.daily: false,
        TaskType.habit: false,
      },
    );
  }

  TaskState copyWith({
    List<TaskEntity>? tasks,
    bool? isLoading,
    String? errorMessage,
    bool? showAllTasks,
    Map<TaskType, bool>? expandedSections,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      showAllTasks: showAllTasks ?? this.showAllTasks,
      expandedSections: expandedSections ?? this.expandedSections,
    );
  }

  @override
  String toString() {
    return 'TaskState(tasks: $tasks, isLoading: $isLoading, errorMessage: $errorMessage, showAllTasks: $showAllTasks)';
  }
}
