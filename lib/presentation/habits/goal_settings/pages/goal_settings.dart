import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teja/presentation/habits/goal_settings/ui/goal_slider.dart';

class GoalSettings extends StatefulWidget {
  const GoalSettings({super.key});

  @override
  _GoalSettingsState createState() => _GoalSettingsState();
}

class _GoalSettingsState extends State<GoalSettings> {
  double sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal Settings"),
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          SmoothPageIndicator(
            controller: controller,
            effect: const ExpandingDotsEffect(),
            count: 8,
          ),
          Expanded(
            child: PageView(
              controller: controller,
              children: const <Widget>[
                GoalSlider(
                  goalName: "Physical",
                  description: "Establishing a regular exercise routine for physical health.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Diet",
                  description: "Maintaining a balanced diet and healthy eating habits.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Emotional",
                  description: "Practices like meditation and mindfulness for stress management.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Sleep",
                  description: "Ensuring a regular sleep schedule and quality rest.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Productivity",
                  description: "Improving efficiency with daily goals and task prioritization.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Financial",
                  description: "Establishing habits for budgeting, saving, and investing.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Personal",
                  description: "Focusing on self-improvement, skill-building, and learning.",
                  initialValue: 0,
                  divisions: 5,
                ),
                GoalSlider(
                  goalName: "Relationships",
                  description: "Cultivating and maintaining meaningful relationships.",
                  initialValue: 0,
                  divisions: 5,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
