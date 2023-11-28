import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:swayam/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:swayam/presentation/navigation/isDesktop.dart';
import 'package:swayam/presentation/profile/ui/profile_weekly_mood_chart.dart';
import 'package:swayam/presentation/profile/ui/radar_chart.dart';
import 'package:swayam/presentation/profile/ui/sleep_analysis.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/common/bento_box.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:swayam/shared/common/flexible_height_box.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final GoRouter goRouter = GoRouter.of(context);

    const ticks = [1, 2, 3, 4, 5, 7];
    var features = [
      "Health and Fitness",
      "Mental and Emotional Well-being",
      "Personal Development",
      "Financial Management",
      "Relationships and Social Skills",
      "Lifestyle Choices",
    ];
    var data = [
      [3, 4, 2, 5, 3, 2],
    ];
    bool useSides = false;

    return Scaffold(
      bottomNavigationBar:
          isDesktop(context) ? null : buildMobileNavigationBar(context),
      appBar: AppBar(
        title: const Text('Profile'),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        key: const Key("profileContainer"),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            FlexibleHeightBox(
              gridWidth: 4,
              child: Column(children: [
                Text(
                  "Goal Finder",
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                BentoBox(
                  key: const Key("RadarBento"),
                  gridWidth: 4,
                  gridHeight: 2.8,
                  margin: 0,
                  padding: 0,
                  color: colorSchema.background,
                  child: GoalChart.dark(
                    ticks: ticks,
                    features: features,
                    data: data,
                    reverseAxis: false,
                    graphColors: [colorSchema.primary],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Button(
                  text: "Edit Goal",
                  buttonType: ButtonType.primary,
                  width: 200,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    goRouter.pushNamed(RootPath.goalSettings);
                  },
                ),
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Health",
              style: textTheme.titleLarge,
            ),
            BentoBox(
              gridWidth: 4,
              gridHeight: 5,
              child: Column(children: [
                Text(
                  "Sleep",
                  style: textTheme.titleSmall,
                ),
                BentoBox(
                  key: const Key("SleepBox"),
                  gridWidth: 4,
                  gridHeight: 3,
                  margin: 0,
                  padding: 0,
                  color: colorSchema.background,
                  child: const SleepAnalysisWidget(),
                ),
              ]),
            ),
            const ProfileWeeklyMoodChart(),
          ],
        ),
      ),
    );
  }
}
