import 'package:flutter/material.dart';

class Goal {
  final IconData iconData;
  final String title;
  final String description;
  bool isSelected;
  int? order;

  Goal({
    required this.iconData,
    required this.title,
    required this.description,
    this.isSelected = false,
    this.order,
  });
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onTap;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    return Card(
      color: goal.isSelected ? colorSchema.surface : colorSchema.background, // Change color to indicate selection
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                goal.iconData,
                size: 48,
                color: goal.isSelected ? colorSchema.background : colorSchema.surface,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: TextStyle(
                        color: goal.isSelected ? colorSchema.background : colorSchema.surface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: TextStyle(
                        color: goal.isSelected ? colorSchema.background : colorSchema.surface,
                      ),
                    ),
                  ],
                ),
              ),
              if (goal.order != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    goal.order.toString(),
                    style: TextStyle(
                      color: colorSchema.background,
                      fontSize: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
