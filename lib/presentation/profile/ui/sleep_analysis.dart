import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SleepAnalysisWidget extends StatefulWidget {
  const SleepAnalysisWidget({Key? key}) : super(key: key);

  @override
  _SleepAnalysisWidgetState createState() => _SleepAnalysisWidgetState();
}

class _SleepAnalysisWidgetState extends State<SleepAnalysisWidget> {
  final HealthFactory _health = HealthFactory();
  bool _isLoading = true;
  final Map<String, double> _sleepDurationPerDay = {};

  @override
  void initState() {
    super.initState();
    _fetchSleepData();
  }

  @override
  void reassemble() {
    super.reassemble();
    _fetchSleepData();
  }

  Future<void> _fetchSleepData() async {
    // Resetting data
    setState(() {
      _isLoading = true;
      _sleepDurationPerDay.clear(); // Clear existing data
    });

    DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
    DateTime endDate = DateTime.now();
    HealthDataType dataType = HealthDataType.SLEEP_IN_BED;

    bool accessGranted = await _health.requestAuthorization([dataType]);

    if (accessGranted) {
      try {
        List<HealthDataPoint> healthData = await _health
            .getHealthDataFromTypes(startDate, endDate, [dataType]);
        _processSleepData(healthData);
      } catch (e) {
        print("Error fetching sleep data: $e");
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _processSleepData(List<HealthDataPoint> data) {
    for (var point in data) {
      String day = DateFormat('yyyy-MM-dd').format(point.dateFrom);
      double durationInMinutes = double.tryParse(point.value.toString()) ?? 0;
      double durationInHours =
          durationInMinutes / 60; // Convert minutes to hours
      print("durationInHours ${durationInHours}");
      _sleepDurationPerDay.update(
        day,
        (existingValue) => existingValue + durationInHours,
        ifAbsent: () => durationInHours,
      );
    }
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> barGroups = [];
    int barIndex = 0;

    _sleepDurationPerDay.forEach((day, duration) {
      barGroups.add(
        BarChartGroupData(
          x: barIndex++,
          barRods: [BarChartRodData(toY: duration)],
          showingTooltipIndicators: [0],
        ),
      );
    });

    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : _sleepDurationPerDay.isEmpty
              ? const Text("No sleep data available.")
              // : const Text("No sleep data available.")
              : BarChart(
                  BarChartData(
                    barGroups: _generateBarGroups(),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            String day = _sleepDurationPerDay.keys.elementAt(
                                value.toInt() % _sleepDurationPerDay.length);
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(day),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                  ),
                ),
    );
  }
}
