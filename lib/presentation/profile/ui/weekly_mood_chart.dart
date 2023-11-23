import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
              // colors: [currentWeekColor],
              color: widget.currentWeekColor,
              spots: widget.currentWeekSpots,
              isCurved: true,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              // colors: [previousWeekColor],
              color: widget.previousWeekColor,
              spots: widget.previousWeekSpots,
              isCurved: true,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
          ],
          minY: 1,
          maxY: 5,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
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
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
      space: 8, // To control the spacing from the axis
    );
  }
}
