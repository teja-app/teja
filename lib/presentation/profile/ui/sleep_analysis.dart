import 'package:flutter/material.dart';
import 'package:health/health.dart';

class SleepAnalysisWidget extends StatefulWidget {
  const SleepAnalysisWidget({super.key});

  @override
  _SleepAnalysisWidgetState createState() => _SleepAnalysisWidgetState();
}

class _SleepAnalysisWidgetState extends State<SleepAnalysisWidget> {
  final HealthFactory _health = HealthFactory();
  List<HealthDataPoint> _sleepData = [];
  bool _isLoading = true;

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
    DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
    DateTime endDate = DateTime.now();
    HealthDataType dataType = HealthDataType.SLEEP_IN_BED;

    bool accessGranted = await _health.requestAuthorization([dataType]);
    print("accessGranted ${accessGranted}");

    if (accessGranted) {
      try {
        List<HealthDataPoint> healthData = await _health
            .getHealthDataFromTypes(startDate, endDate, [dataType]);
        _sleepData = healthData;
        print("_sleepData ${_sleepData}");
      } catch (e) {
        print("Error fetching sleep data: $e");
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : _sleepData.isEmpty
              ? const Text("No sleep data available.")
              : Text("Sleep Data ${_sleepData.length}"),
    );
  }
}
