import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:health/health.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/presentation/profile/ui/mood_sleep_chart.dart';
import 'package:teja/presentation/profile/ui/sleep_service.dart';

class MoodSleepChartScreen extends StatefulWidget {
  const MoodSleepChartScreen({super.key});

  @override
  State<MoodSleepChartScreen> createState() => _MoodSleepChartScreenState();
}

class _MoodSleepChartScreenState extends State<MoodSleepChartScreen> {
  late MoodSleepChartViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime now = DateTime.now();
      final DateTime today =
          DateTime(now.year, now.month, now.day); // Reset time to midnight
      StoreProvider.of<AppState>(context)
          .dispatch(FetchMonthlyMoodReportAction(today));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MoodSleepChartViewModel>(
      converter: (store) {
        final viewModel = MoodSleepChartViewModel.fromStore(store);
        viewModel.fetchSleepData();
        return viewModel;
      },
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: MoodSleepChart(
            key: const Key('moodSleepChart'),
            scatterData: viewModel.scatterData,
            // find max element in scatterData and set it as maxX using max
            maxX: viewModel.scatterData.isNotEmpty
                ? viewModel.scatterData.map((spot) => spot.x).reduce(
                        (value, element) => value > element ? value : element) +
                    1
                : 15,
            // maxX: viewModel.scatterData.
          ),
        );
      },
    );
  }
}

class MoodSleepChartViewModel {
  final bool isLoading;
  final Map<DateTime, double> moodData;
  List<ScatterSpot> scatterData;

  MoodSleepChartViewModel({
    required this.isLoading,
    required this.moodData,
    required this.scatterData,
  });

  factory MoodSleepChartViewModel.fromStore(Store<AppState> store) {
    final state = store.state.monthlyMoodReportState;

    return MoodSleepChartViewModel(
      isLoading: state.isLoading,
      moodData: state.currentMonthAverageMoodRatings,
      scatterData: const [], // Initialize with an empty list
    );
  }

  Future<void> fetchSleepData() async {
    List<DateTime> dates = moodData.keys.toList();
    final sleepData = await HealthDataFetcher.fetchHealthData(dates);
    scatterData = _mapToScatterSpots(moodData, sleepData);
  }

  static List<ScatterSpot> _mapToScatterSpots(
      Map<DateTime, double> moodData, List<HealthDataPoint> sleepData) {
    final Map<DateTime, double> sleepMap = {};
    for (final dataPoint in sleepData) {
      final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
          dataPoint.dateFrom.day);
      final value = dataPoint.value;
      double duration;

      final valueString = value.toString();
      if (valueString.contains('numericValue')) {
        final numericValueString = valueString.split('numericValue:')[1].trim();
        duration = double.parse(numericValueString) / 60; // Convert to hours
      } else if (valueString.contains('instantValue')) {
        final instantValueString = valueString.split('instantValue:')[1].trim();
        final instantValue = DateTime.parse(instantValueString);
        duration = instantValue
            .difference(DateTime.fromMillisecondsSinceEpoch(0))
            .inHours
            .toDouble();
      } else {
        continue;
      }

      if (sleepMap.containsKey(date)) {
        sleepMap[date] = sleepMap[date]! + duration;
      } else {
        sleepMap[date] = duration;
      }
    }

    final List<ScatterSpot> scatterSpots = [];
    moodData.forEach((moodDate, moodValue) {
      final sleepDate = moodDate.subtract(const Duration(days: 1));
      final sleepDateOnly =
          DateTime(sleepDate.year, sleepDate.month, sleepDate.day);
      if (sleepMap.containsKey(sleepDateOnly)) {
        final sleepValue = sleepMap[sleepDateOnly]!;
        scatterSpots.add(ScatterSpot(sleepValue, moodValue,
            radius: calculateRadius(moodValue),
            color: Colors.blue.withOpacity(0.1 * moodValue)));
      }
    });

    print('scatterSpots: $scatterSpots');

    return scatterSpots;
  }
}

double calculateRadius(double mood) {
  // Define the minimum and maximum radius
  double minRadius = 1.0;
  double maxRadius = 15.0;

  // Scale mood values from 1 to 5 to radius from minRadius to maxRadius
  return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
}
