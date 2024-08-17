import 'package:flutter/material.dart';
import 'package:teja/presentation/task/interface/task.dart';

class PriorityCheckbox extends StatelessWidget {
  final Task task;
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

    return GestureDetector(
      onTap: () => onChanged(!task.isCompleted),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: priorityColor,
            width: 2,
          ),
          color: task.isCompleted ? priorityColor : Colors.transparent,
        ),
        child: task.isCompleted
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
