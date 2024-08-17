import 'package:flutter/material.dart';
import 'package:teja/presentation/task/interface/task.dart';
import 'package:teja/presentation/task/page/task_edit.dart';
import 'package:teja/presentation/task/page/task_detail.dart';
import 'package:teja/presentation/task/ui/PriorityCheckbox.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Function(Task) updateTask;
  final Function(String) toggleTask;
  final Function(String, HabitDirection) incrementHabit;
  final String? activePomodoro;
  final bool isRunning;
  final int pomodoroTime;
  final bool isBreak;
  final Function(String) togglePomodoro;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.updateTask,
    required this.toggleTask,
    required this.incrementHabit,
    required this.activePomodoro,
    required this.isRunning,
    required this.pomodoroTime,
    required this.isBreak,
    required this.togglePomodoro,
  }) : super(key: key);

  Color _getPriorityColor() {
    switch (task.priority) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getShortDueDate() {
    if (task.due == null) return "";
    final now = DateTime.now();
    final difference = task.due!.date.difference(now);

    if (difference.inDays == 0) return "Today";
    if (difference.inDays == 1) return "Tomorrow";
    if (difference.inDays > 1 && difference.inDays < 7) {
      return _weekdayName(task.due!.date.weekday);
    }
    return "${task.due!.date.month}/${task.due!.date.day}";
  }

  String _weekdayName(int weekday) {
    const days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday];
  }

  void _openTaskPage(BuildContext context) {
    if (task.type == TaskType.todo) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskEditorPage(
            task: task,
            onSave: updateTask,
            initialTaskType: task.type,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskDetailPage(
            task: task,
            updateTask: updateTask,
            toggleTask: toggleTask,
          ),
        ),
      );
    }
  }

  Widget _buildHabitButton(HabitDirection direction) {
    return IconButton(
      icon: Icon(
        direction == HabitDirection.positive ? Icons.add : Icons.remove,
        color: direction == HabitDirection.positive ? Colors.green : Colors.red,
      ),
      onPressed: () => incrementHabit(task.id, direction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openTaskPage(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            if (task.type != TaskType.habit)
              PriorityCheckbox(
                task: task,
                onChanged: (_) => toggleTask(task.id),
                priorityColor: _getPriorityColor(),
              )
            else if (task.habitDirection == HabitDirection.positive || task.habitDirection == HabitDirection.both)
              _buildHabitButton(HabitDirection.positive),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: task.type == TaskType.todo && task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.type == TaskType.todo && task.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  if (task.description?.isNotEmpty ?? false)
                    Text(
                      task.description!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (task.type == TaskType.todo) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(_getShortDueDate(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 8),
                        const Icon(Icons.label, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          task.labels.isNotEmpty ? task.labels[0] : 'No label',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                  if (task.type == TaskType.habit) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Positive: ${task.getHabitCount(HabitDirection.positive)}, Negative: ${task.getHabitCount(HabitDirection.negative)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  if (task.type == TaskType.daily) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Last completed: ${task.getLastCompletedDate()}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            if (task.type == TaskType.habit &&
                (task.habitDirection == HabitDirection.negative || task.habitDirection == HabitDirection.both))
              _buildHabitButton(HabitDirection.negative)
            else if (task.type != TaskType.habit)
              IconButton(
                icon: Icon(
                  activePomodoro == task.id && isRunning ? Icons.pause : Icons.play_arrow,
                  size: 18,
                ),
                onPressed: () => togglePomodoro(task.id),
              ),
          ],
        ),
      ),
    );
  }
}
