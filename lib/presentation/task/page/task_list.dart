import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/presentation/navigation/mobile_navigation_bar.dart';
import 'package:teja/presentation/task/interface/task.dart';
import 'package:teja/presentation/task/page/task_edit.dart';
import 'package:teja/presentation/task/ui/TaskWidget.dart';
import 'package:teja/presentation/task/ui/PomodoroOverlay.dart';
import 'package:teja/router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/domain/redux/tasks/task_action.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  static const int POMODORO_DURATION = 25 * 60;
  static const int BREAK_DURATION = 5 * 60;

  String? activePomodoro;
  int pomodoroTime = POMODORO_DURATION;
  bool isBreak = false;
  bool isRunning = false;

  Timer? pomodoroTimer;

  @override
  void dispose() {
    pomodoroTimer?.cancel();
    super.dispose();
  }

  void togglePomodoro(String taskId) {
    setState(() {
      if (activePomodoro == taskId) {
        isRunning = !isRunning;
      } else {
        activePomodoro = taskId;
        pomodoroTime = POMODORO_DURATION;
        isBreak = false;
        isRunning = true;
      }
    });

    if (isRunning) {
      pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (pomodoroTime > 0) {
            pomodoroTime--;
          } else {
            if (isBreak) {
              isBreak = false;
              pomodoroTime = POMODORO_DURATION;
            } else {
              isBreak = true;
              pomodoroTime = BREAK_DURATION;
            }
            isRunning = false;
            timer.cancel();
          }
        });
      });
    } else {
      pomodoroTimer?.cancel();
    }
  }

  void resetPomodoro() {
    setState(() {
      pomodoroTime = POMODORO_DURATION;
      isBreak = false;
      isRunning = false;
    });
    pomodoroTimer?.cancel();
  }

  void _openTaskEditor(BuildContext context, TaskListViewModel viewModel,
      {TaskEntity? task, required TaskType initialTaskType}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditorPage(
          task: task,
          initialTaskType: initialTaskType,
        ),
      ),
    );
  }

  Widget _buildTaskTypeSection(TaskType taskType, BuildContext context, TaskListViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;
    List<TaskEntity> filteredTasks = viewModel.tasks.where((task) => task.type == taskType).toList();
    return ExpansionTile(
      initiallyExpanded: taskType == TaskType.todo,
      title: Text('${taskType.toString().split('.').last} (${filteredTasks.length})', style: textTheme.titleMedium),
      children: filteredTasks
          .map((task) => TaskWidget(
                task: task,
                updateTask: (task) => _openTaskEditor(context, viewModel, task: task, initialTaskType: taskType),
                toggleTask: viewModel.toggleTask,
                activePomodoro: activePomodoro,
                incrementHabit: viewModel.incrementHabit,
                isRunning: isRunning,
                pomodoroTime: pomodoroTime,
                isBreak: isBreak,
                togglePomodoro: togglePomodoro,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TaskListViewModel>(
      converter: (store) => TaskListViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          bottomNavigationBar: isDesktop(context) ? null : const MobileNavigationBar(),
          appBar: AppBar(
            elevation: 0.0,
            forceMaterialTransparency: true,
            leading: leadingNavBar(context),
            leadingWidth: 72,
            title: const Text('Tasks'),
            actions: [
              IconButton(
                icon: const Icon(AntDesign.heart),
                onPressed: () {
                  GoRouter.of(context).pushNamed(
                    RootPath.goalSettings,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _openTaskEditor(context, viewModel, initialTaskType: TaskType.todo),
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                children: TaskType.values.map((type) => _buildTaskTypeSection(type, context, viewModel)).toList(),
              ),
              if (activePomodoro != null)
                PomodoroOverlay(
                  activeTask: viewModel.tasks.firstWhere((t) => t.id == activePomodoro),
                  pomodoroTime: pomodoroTime,
                  isRunning: isRunning,
                  isBreak: isBreak,
                  togglePomodoro: togglePomodoro,
                  resetPomodoro: resetPomodoro,
                  closePomodoro: () => setState(() {
                    activePomodoro = null;
                    isRunning = false;
                    pomodoroTimer?.cancel();
                  }),
                ),
            ],
          ),
        );
      },
    );
  }
}

class TaskListViewModel {
  final List<TaskEntity> tasks;
  final Function(String) toggleTask;
  final Function(String, HabitDirection) incrementHabit;
  final Function(TaskEntity) addTask;
  final Function(TaskEntity) updateTask;

  TaskListViewModel({
    required this.tasks,
    required this.toggleTask,
    required this.incrementHabit,
    required this.addTask,
    required this.updateTask,
  });

  static TaskListViewModel fromStore(Store<AppState> store) {
    return TaskListViewModel(
      tasks: store.state.taskState.tasks,
      toggleTask: (String taskId) => store.dispatch(ToggleTaskCompletionAction(taskId)),
      incrementHabit: (String taskId, HabitDirection direction) =>
          store.dispatch(IncrementHabitAction(taskId, direction)),
      addTask: (TaskEntity task) => store.dispatch(AddTaskAction(task)),
      updateTask: (TaskEntity task) => store.dispatch(UpdateTaskAction(task)),
    );
  }
}
