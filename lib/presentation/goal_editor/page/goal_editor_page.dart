import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teja/presentation/goal_editor/ui/goal_card.dart';
import 'package:teja/shared/common/button.dart';

class GoalEditorPage extends StatefulWidget {
  @override
  _GoalEditorPageState createState() => _GoalEditorPageState();
}

class _GoalEditorPageState extends State<GoalEditorPage> {
  final List<Goal> goals = [
    Goal(
      iconData: Icons.work,
      title: 'Career Growth',
      description: 'Enhance your professional skills and career advancement.',
    ),
    Goal(
      iconData: Icons.health_and_safety,
      title: 'Wellness',
      description: 'Focus on physical health, mental well-being, and a balanced lifestyle.',
    ),
    Goal(
      iconData: Icons.lightbulb,
      title: 'Self-Improvement',
      description: 'Work on personal growth and learn new skills.',
    ),
    Goal(
      iconData: Icons.group,
      title: 'Social Life',
      description: 'Strengthen relationships and engage in community activities.',
    ),
    Goal(
      iconData: Icons.account_balance_wallet,
      title: 'Financial Health',
      description: 'Work towards financial security and effective wealth management.',
    ),
    Goal(
      iconData: Icons.airplanemode_active,
      title: 'Adventures',
      description: 'Seek new experiences and explore for adventure and discovery.',
    ),
    Goal(
      iconData: Icons.volunteer_activism,
      title: 'Social Impact',
      description: 'Contribute to society and make a positive impact in your community.',
    ),
  ];
  void _handleGoalTap(Goal goal) {
    setState(() {
      if (!goal.isSelected) {
        // Select the goal and assign the next order number
        goal.isSelected = true;
        goal.order = goals.where((g) => g.isSelected).length;
      } else {
        // Unselect the goal and remove its order number
        goal.isSelected = false;
        // Save the order number before setting it to null
        final int? currentOrder = goal.order;
        goal.order = null;
        // Update the order of all goals that had a higher order number
        goals.where((g) => g.order != null && g.order! > currentOrder!).forEach((g) {
          g.order = g.order! - 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your goals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Which areas of your life are you most excited to enhance? Let's prioritize your journey to well-being.",
              style: textTheme.titleSmall,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return GoalCard(
                    goal: goals[index],
                    onTap: () => _handleGoalTap(goals[index]),
                  );
                },
              ),
            ),
            Button(
              text: "Save Goal",
              buttonType: ButtonType.primary,
              width: 200,
              onPressed: () {
                HapticFeedback.selectionClick();
                // Handle save action
              },
            ),
          ],
        ),
      ),
    );
  }
}
