import 'package:flutter/material.dart';
import 'package:teja/domain/entities/task_entity.dart';

class PriorityCheckbox extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onChanged;
  final Color priorityColor;

  const PriorityCheckbox({
    Key? key,
    required this.task,
    required this.onChanged,
    required this.priorityColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (task.type == TaskType.habit) {
      return const SizedBox.shrink();
    }

    bool isCompleted = task.type == TaskType.todo
        ? task.completedAt != null
        : task.completedDates.contains(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ));

    return GestureDetector(
      onTap: () => onChanged(!isCompleted),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: priorityColor,
            width: 2,
          ),
          color: isCompleted ? priorityColor : Colors.transparent,
        ),
        child: isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
