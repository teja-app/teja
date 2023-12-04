// lib/widgets/habit_list_item.dart

import 'package:flutter/material.dart';
import 'package:teja/domain/entities/habit_entity.dart';

class HabitListItem extends StatelessWidget {
  final HabitEntity habit;

  const HabitListItem({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.check_circle_outline),
      title: Text(habit.title),
      subtitle: Text(habit.description),
      trailing: Text('${habit.quantity} ${habit.unit}'),
    );
  }
}
