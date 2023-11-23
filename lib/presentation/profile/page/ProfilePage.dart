import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swayam/presentation/navigation/buildDesktopDrawer.dart';
import 'package:swayam/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:swayam/presentation/navigation/isDesktop.dart';
import 'package:swayam/presentation/profile/ui/weekly_mood_chart.dart';
import 'package:swayam/shared/common/bento_box.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> currentWeekSpots = [
      const FlSpot(0, 3), // Mood rating for Monday of the current week
      const FlSpot(1, 4), // Tuesday
      const FlSpot(2, 2), // Wednesday
      const FlSpot(3, 5), // Thursday
      const FlSpot(4, 3), // Friday
      const FlSpot(5, 4), // Saturday
      const FlSpot(6, 3), // Sunday
    ];

    List<FlSpot> previousWeekSpots = [
      const FlSpot(0, 2), // Mood rating for Monday of the previous week
      const FlSpot(1, 3), // Tuesday
      const FlSpot(2, 3), // Wednesday
      const FlSpot(3, 2), // Thursday
      const FlSpot(4, 4), // Friday
      const FlSpot(5, 5), // Saturday
      const FlSpot(6, 4), // Sunday
    ];

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar:
          isDesktop(context) ? null : buildMobileNavigationBar(context),
      drawer: isDesktop(context) ? buildDesktopDrawer(context) : null,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        key: Key("profileContainer"),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildBadgeHeader(),
            BentoBox(
              gridWidth: 4,
              gridHeight: 4,
              child: _buildRadarChart(context),
            ),
            BentoBox(
              gridWidth: 4,
              gridHeight: 4,
              child: WeeklyMoodChart(
                key: Key("WeeklyMoodChart"),
                currentWeekSpots: currentWeekSpots,
                previousWeekSpots: previousWeekSpots,
                currentWeekColor: colorScheme.primary,
                previousWeekColor: colorScheme.secondary.withOpacity(0.2),
              ),
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

    return Center(
      child: Container(
        width: chartWidth,
        height: chartHeight,
        padding:
            const EdgeInsets.all(16), // Add some padding inside the container

        child: RadarChart(
          RadarChartData(
            // radarShape: RadarShape.polygon,
            titlePositionPercentageOffset: 0.1,
            tickCount: 5,
            gridBorderData: const BorderSide(
              width: 0.001,
              color: Colors.white,
            ),
            tickBorderData: const BorderSide(
              width: 0.001,
              color: Colors.white,
            ),
            radarBorderData: const BorderSide(
              width: 0.001,
              color: Colors.white,
            ),
            ticksTextStyle: const TextStyle(color: Colors.white, fontSize: 0),
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
            getTitle: (int index, double angle) {
              return getTitle(index, angle);
            },
            dataSets: showingDataSets(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 400),
          swapAnimationCurve: Curves.decelerate,
        ),
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
        ],
      ),
    ];
  }

  // Implement getTitle function to return titles for each index
  RadarChartTitle getTitle(int index, double angle) {
    switch (index) {
      case 0:
        return RadarChartTitle(text: "Eating", angle: angle);
      case 1:
        return RadarChartTitle(text: "Sleeping", angle: angle);
      case 2:
        return RadarChartTitle(text: "Working", angle: angle);
      case 3:
        return RadarChartTitle(text: "Exercising", angle: angle);
      case 4:
        return RadarChartTitle(text: "Relaxing", angle: angle);
      default:
        return RadarChartTitle(text: "-", angle: angle);
    }
  }
}
