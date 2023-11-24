import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swayam/shared/helpers/color.dart';

class WeeklyMoodChart extends StatefulWidget {
  final List<FlSpot> currentWeekSpots;
  final List<FlSpot> previousWeekSpots;
  final Color currentWeekColor;
  final Color previousWeekColor;

  const WeeklyMoodChart({
    Key? key,
    required this.currentWeekSpots,
    required this.previousWeekSpots,
    this.currentWeekColor = Colors.blue,
    this.previousWeekColor = Colors.red,
  }) : super(key: key);

  @override
  _WeeklyMoodChartState createState() => _WeeklyMoodChartState();
}

class _WeeklyMoodChartState extends State<WeeklyMoodChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              gradient: LinearGradient(
                colors: [
                  widget.currentWeekColor,
                  darken(widget.currentWeekColor, 0.25),
                ],
              ),
              spots: widget.currentWeekSpots,
              isCurved: true,
              barWidth: 10,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              color: widget.previousWeekColor,
              spots: widget.previousWeekSpots,
              isCurved: true,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
            ),
          ],
          minY: 1,
          maxY: 5,
          minX: 0,
          maxX: 7,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => _buildMoodIcon(
                  value.toInt(),
                  meta,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: bottomTitles,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(
            show: false,
            drawVerticalLine: true,
            horizontalInterval: 1,
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(
              color: const Color(0xff37434d),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: text, // To control the spacing from the axis
    );
  }
}

Widget _buildMoodIcon(int moodRating, TitleMeta meta) {
  String moodIconPath = 'assets/icons/mood_${moodRating}_inactive.svg';
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: SvgPicture.asset(
      moodIconPath,
      width: 16,
      height: 20,
    ),
  );
}
