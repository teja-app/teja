// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:health/health.dart';
// import 'package:redux/redux.dart';
// import 'package:teja/domain/redux/app_state.dart';
// import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
// import 'package:teja/presentation/profile/ui/mood_sleep_chart.dart';
// import 'package:teja/presentation/profile/ui/sleep_service.dart';

// class MoodSleepChartScreen extends StatefulWidget {
//   const MoodSleepChartScreen({super.key});

//   @override
//   State<MoodSleepChartScreen> createState() => _MoodSleepChartScreenState();
// }

// class _MoodSleepChartScreenState extends State<MoodSleepChartScreen> {
//   late MoodSleepChartViewModel viewModel;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final DateTime now = DateTime.now();
//       final DateTime today =
//           DateTime(now.year, now.month, now.day); // Reset time to midnight
//       StoreProvider.of<AppState>(context)
//           .dispatch(FetchMonthlyMoodReportAction(today));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, MoodSleepChartViewModel>(
//       converter: (store) {
//         final viewModel = MoodSleepChartViewModel.fromStore(store);
//         viewModel.fetchSleepData();
//         return viewModel;
//       },
//       builder: (context, viewModel) {
//         if (viewModel.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return ConstrainedBox(
//           constraints: const BoxConstraints(
//               maxHeight: 400), // Set a maximum height constraint
//           child: MoodSleepChart(
//             key: const Key('moodSleepChart'),
//             moodData: viewModel.moodData.entries.map((entry) {
//               return FlSpot(
//                   entry.key.millisecondsSinceEpoch.toDouble(), entry.value);
//             }).toList(),
//             sleepData: viewModel.sleepData,
//           ),
//         );
//       },
//     );
//   }
// }
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

        print('scatterData: ${viewModel.scatterData}');
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: MoodSleepChart(
            key: const Key('moodSleepChart'),
            scatterData: viewModel.scatterData,
          ),
        );
      },
    );
  }
}

// class MoodSleepChartViewModel {
//   final bool isLoading;
//   final Map<DateTime, double> moodData;
//   List<FlSpot> sleepData;

//   MoodSleepChartViewModel({
//     required this.isLoading,
//     required this.moodData,
//     required this.sleepData,
//   });

//   factory MoodSleepChartViewModel.fromStore(Store<AppState> store) {
//     final state = store.state.monthlyMoodReportState;

//     return MoodSleepChartViewModel(
//       isLoading: state.isLoading,
//       moodData: state.currentMonthAverageMoodRatings,
//       sleepData: const [], // Initialize with an empty list
//     );
//   }

//   Future<void> fetchSleepData() async {
//     final sleepData = await HealthDataFetcher.fetchHealthData();
//     this.sleepData = _mapMonthlySleepDataToFlSpots(sleepData);
//   }

//   static List<FlSpot> _mapToFlSpots(Map<DateTime, double> data) {
//     return data.entries
//         .map((entry) => FlSpot(entry.key.weekday.toDouble(), entry.value))
//         .toList();
//   }

//   static List<FlSpot> _mapMonthlySleepDataToFlSpots(
//       List<HealthDataPoint> sleepData) {
//     final Map<int, double> dailySleepMap = {}; // Using day of month as the key
//     for (final dataPoint in sleepData) {
//       final date = dataPoint.dateFrom;
//       final dayOfMonth = date.day;
//       final value = dataPoint.value;
//       double duration;

//       final valueString = value.toString();
//       if (valueString.contains('numericValue')) {
//         // Extract the numeric value from the string
//         final numericValueString = valueString.split('numericValue:')[1].trim();
//         duration = double.parse(numericValueString) / 60; // Convert to hours
//       } else if (valueString.contains('instantValue')) {
//         // Extract the instant value from the string
//         final instantValueString = valueString.split('instantValue:')[1].trim();
//         final instantValue = DateTime.parse(instantValueString);
//         duration = instantValue
//             .difference(DateTime.fromMillisecondsSinceEpoch(0))
//             .inHours
//             .toDouble();
//       } else {
//         // Handle other HealthValue types if needed
//         continue;
//       }

//       // Aggregate daily sleep data
//       if (dailySleepMap.containsKey(dayOfMonth)) {
//         if (dailySleepMap.containsKey(dayOfMonth)) {
//           dailySleepMap[dayOfMonth] =
//               (dailySleepMap[dayOfMonth] ?? 0) + duration;
//         } else {
//           dailySleepMap[dayOfMonth] = duration;
//         }
//       } else {
//         dailySleepMap[dayOfMonth] = duration;
//       }
//     }

//     // Map aggregated daily sleep data to FlSpots
//     return dailySleepMap.entries
//         .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
//         .toList();
//   }
// }
// class MoodSleepChartViewModel {
//   final bool isLoading;
//   final Map<DateTime, double> moodData;
//   List<ScatterSpot> scatterData;

//   MoodSleepChartViewModel({
//     required this.isLoading,
//     required this.moodData,
//     required this.scatterData,
//   });

//   factory MoodSleepChartViewModel.fromStore(Store<AppState> store) {
//     final state = store.state.monthlyMoodReportState;

//     return MoodSleepChartViewModel(
//       isLoading: state.isLoading,
//       moodData: state.currentMonthAverageMoodRatings,
//       scatterData: const [], // Initialize with an empty list
//     );
//   }

//   Future<void> fetchSleepData() async {
//     List<DateTime> dates = moodData.keys.toList();
//     final sleepData = await HealthDataFetcher.fetchHealthData(dates);
//     scatterData = _mapToScatterSpots(moodData, sleepData);
//   }

//   static List<ScatterSpot> _mapToScatterSpots(
//       Map<DateTime, double> moodData, List<HealthDataPoint> sleepData) {
//     final Map<DateTime, double> sleepMap = {};
//     for (final dataPoint in sleepData) {
//       final date = dataPoint.dateFrom;
//       final value = dataPoint.value;
//       double duration;

//       final valueString = value.toString();
//       if (valueString.contains('numericValue')) {
//         final numericValueString = valueString.split('numericValue:')[1].trim();
//         duration = double.parse(numericValueString) / 60; // Convert to hours
//       } else if (valueString.contains('instantValue')) {
//         final instantValueString = valueString.split('instantValue:')[1].trim();
//         final instantValue = DateTime.parse(instantValueString);
//         duration = instantValue
//             .difference(DateTime.fromMillisecondsSinceEpoch(0))
//             .inHours
//             .toDouble();
//       } else {
//         continue;
//       }

//       sleepMap[date] = duration;
//     }

//     final List<ScatterSpot> scatterSpots = [];
//     moodData.forEach((moodDate, moodValue) {
//       final sleepDate = moodDate.subtract(const Duration(days: 1));
//       if (sleepMap.containsKey(sleepDate)) {
//         final sleepValue = sleepMap[sleepDate]!;
//         scatterSpots.add(ScatterSpot(sleepValue, moodValue));
//       }
//     });

//     return scatterSpots;
//   }
// }
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
            radius: calculateRadius(moodValue)));
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
