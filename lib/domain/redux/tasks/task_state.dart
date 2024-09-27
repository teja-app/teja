import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/task_entity.dart';

@immutable
class TaskState {
  final List<TaskEntity> tasks;
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    required this.tasks,
    this.isLoading = false,
    this.errorMessage,
  });

  factory TaskState.initial() {
    return const TaskState(
      tasks: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  TaskState copyWith({
    List<TaskEntity>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'TaskState(tasks: $tasks, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
