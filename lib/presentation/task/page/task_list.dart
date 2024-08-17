import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/presentation/navigation/mobile_navigation_bar.dart';
import 'package:teja/presentation/task/interface/task.dart';
import 'package:teja/presentation/task/mock/mock.dart';
import 'package:teja/presentation/task/page/task_edit.dart';
import 'package:teja/presentation/task/ui/TaskWidget.dart';
import 'package:teja/presentation/task/ui/PomodoroOverlay.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  static const int POMODORO_DURATION = 25 * 60;
  static const int BREAK_DURATION = 5 * 60;

  List<Task> allTasks = mockTasks;

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

  void toggleTask(String taskId) {
    setState(() {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      task.toggleCompletion();
    });
  }

  void incrementHabit(String taskId, HabitDirection direction) {
    setState(() {
      final task = allTasks.firstWhere((t) => t.id == taskId);
      task.incrementHabit(direction);
    });
  }

  void addTask(Task newTask) {
    setState(() {
      allTasks.add(newTask);
    });
  }

  void updateTask(Task updatedTask) {
    setState(() {
      final index = allTasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        allTasks[index] = updatedTask;
      }
    });
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

  void _openTaskEditor(BuildContext context, {Task? task, required TaskType initialTaskType}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditorPage(
          task: task,
          onSave: task == null ? addTask : updateTask,
          initialTaskType: initialTaskType,
        ),
      ),
    );
  }

  Widget _buildTaskTypeSection(TaskType taskType) {
    List<Task> filteredTasks = allTasks.where((task) => task.type == taskType).toList();
    return ExpansionTile(
      initiallyExpanded: taskType == TaskType.todo,
      title: Text(
        '${taskType.toString().split('.').last} (${filteredTasks.length})',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: filteredTasks
          .map((task) => TaskWidget(
                task: task,
                updateTask: (task) => _openTaskEditor(context, task: task, initialTaskType: taskType),
                toggleTask: toggleTask,
                activePomodoro: activePomodoro,
                incrementHabit: incrementHabit,
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
            icon: const Icon(Icons.add),
            onPressed: () => _openTaskEditor(context, initialTaskType: TaskType.todo),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: TaskType.values.map(_buildTaskTypeSection).toList(),
          ),
          if (activePomodoro != null)
            PomodoroOverlay(
              activeTask: allTasks.firstWhere((t) => t.id == activePomodoro),
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
  }
}
