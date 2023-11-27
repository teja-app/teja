import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swayam/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:swayam/presentation/navigation/isDesktop.dart';
import 'package:swayam/presentation/profile/ui/profile_weekly_mood_chart.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/common/bento_box.dart';
import 'package:swayam/shared/common/button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    final GoRouter goRouter = GoRouter.of(context);

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
            const ProfileWeeklyMoodChart(),
            // _buildBadgeHeader(),
            BentoBox(
              gridWidth: 4,
              gridHeight: 5,
              child: Column(children: [
                BentoBox(
                  key: const Key("RadarBento"),
                  gridWidth: 4,
                  gridHeight: 2.8,
                  margin: 0,
                  padding: 0,
                  color: colorSchema.background,
                  child: _buildRadarChart(context),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeHeader() {
    String badgeFrame = "assets/mood/frame.svg";
    String badgeImage = "assets/mood/badge/GenesisSpiral.png";
    return Column(
      children: [
        Stack(
          alignment:
              Alignment.center, // Align the child to the center of the stack
          children: [
            SvgPicture.asset(
              badgeFrame,
              width: 300,
              height: 300,
            ),
            Image.asset(
              badgeImage,
              width: 150,
              height: 150,
            ),
          ],
        ),
        const Text(
          'Genesis Spiral',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRadarChart(BuildContext context) {
    // Adjust the width and height by changing the multiplier
    // Set a fixed width and height for the chart
    double chartWidth = MediaQuery.of(context).size.width *
        0.8; // for example, 80% of screen width
    double chartHeight = MediaQuery.of(context).size.width *
        0.5; // and 50% of screen width for height

    final colorSchema = Theme.of(context).colorScheme;
    return Container(
      key: const Key("RadarChart"),
      width: chartWidth,
      height: chartHeight,
      padding:
          const EdgeInsets.all(16), // Add some padding inside the container
      child: RadarChart(
        RadarChartData(
          // radarShape: RadarShape.polygon,
          titlePositionPercentageOffset: 0.1,
          tickCount: 5,
          gridBorderData: BorderSide(
            width: 0.001,
            color: colorSchema.background,
          ),
          tickBorderData: BorderSide(
            width: 0.001,
            color: colorSchema.background,
          ),
          radarBorderData: BorderSide(
            width: 0.001,
            color: colorSchema.background,
          ),
          ticksTextStyle: TextStyle(
            color: colorSchema.background,
            fontSize: 0,
          ),
          titleTextStyle: TextStyle(
            color: colorSchema.surface,
            fontSize: 10,
          ),
          getTitle: (int index, double angle) {
            return getTitle(index, angle);
          },
          dataSets: showingDataSets(),
        ),
        swapAnimationDuration: const Duration(milliseconds: 400),
        swapAnimationCurve: Curves.decelerate,
      ),
    );
  }

  // Dummy data for radar chart
  List<RadarDataSet> showingDataSets() {
    return [
      RadarDataSet(
        fillColor: Colors.black.withOpacity(0.3),
        borderColor: Colors.black.withOpacity(0.1),
        borderWidth: 0,
        entryRadius: 2,
        dataEntries: [
          const RadarEntry(value: 3),
          const RadarEntry(value: 2),
          const RadarEntry(value: 4),
          const RadarEntry(value: 5),
          const RadarEntry(value: 3),
          const RadarEntry(value: 3),
          const RadarEntry(value: 4),
          const RadarEntry(value: 5),
        ],
      ),
    ];
  }

  // Implement getTitle function to return titles for each index
  RadarChartTitle getTitle(int index, double angle) {
    List<String> goalTitles = [
      "Physical",
      "Diet",
      "Emotional",
      "Sleep",
      "Productivity",
      "Financial",
      "Personal",
      "Relationships"
    ];

    if (index < goalTitles.length) {
      return RadarChartTitle(text: goalTitles[index], angle: angle);
    } else {
      return RadarChartTitle(text: "-", angle: angle);
    }
  }
}
