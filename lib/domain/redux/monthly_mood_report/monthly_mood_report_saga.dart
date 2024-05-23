// import 'package:isar/isar.dart';
// import 'package:redux_saga/redux_saga.dart';
// import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
// import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

// class MonthlyMoodReportSaga {
//   Iterable<void> saga() sync* {
//     yield TakeEvery(
//       _fetchMonthlyMoodReport,
//       pattern: FetchMonthlyMoodReportAction,
//     );
//   }

//   _fetchMonthlyMoodReport(
//       {required FetchMonthlyMoodReportAction action}) sync* {
//     yield Try(() sync* {
//       var isarResult = Result<Isar>();
//       yield GetContext('isar', result: isarResult);
//       Isar isar = isarResult.value!;

//       final moodLogRepository = MoodLogRepository(isar);

//       // Calculate the start and end dates for the current and previous months
//       final currentMonthStart = _startOfMonth(action.referenceDate);
//       final currentMonthEnd = _endOfMonth(action.referenceDate);

//       print("currentMonthStart: $currentMonthStart");
//       print("currentMonthEnd: $currentMonthEnd");

//       // Fetch average mood ratings for each month
//       var currentMonthAverageMoodRatingsResult =
//           Result<Map<DateTime, double>>();
//       yield Call(moodLogRepository.getAverageMoodLogsForWeek,
//           args: [currentMonthStart, currentMonthEnd],
//           result: currentMonthAverageMoodRatingsResult);

//       print(
//           "currentMonthAverageMoodRatingsResult: $currentMonthAverageMoodRatingsResult");

//       // Dispatch success action with the average mood ratings
//       yield Put(MonthlyMoodReportFetchedSuccessAction(
//           currentMonthAverageMoodRatingsResult.value!));
//     }, Catch: (e, s) sync* {
//       print("Error fetching monthly mood report: $e");
//       // Dispatch error action
//       yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
//     });
//   }

//   DateTime _startOfMonth(DateTime date) {
//     return DateTime(date.year, date.month, 1);
//   }

//   DateTime _endOfMonth(DateTime date) {
//     // end of current month
//     var nextMonth = DateTime(date.year, date.month + 1, 1);
//     var endOfMonth = nextMonth.subtract(const Duration(days: 1));
//     return endOfMonth;
//   }
// }
// monthly_mood_report_saga.dart

// import 'package:isar/isar.dart';
// import 'package:redux_saga/redux_saga.dart';
// import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
// import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
// import 'package:health/health.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:teja/presentation/profile/ui/sleep_service.dart';

// class MonthlyMoodReportSaga {
//   Iterable<void> saga() sync* {
//     yield TakeEvery(
//       _fetchMonthlyMoodReport,
//       pattern: FetchMonthlyMoodReportAction,
//     );
//   }

//   _fetchMonthlyMoodReport(
//       {required FetchMonthlyMoodReportAction action}) sync* {
//     yield Try(() sync* {
//       var isarResult = Result<Isar>();
//       yield GetContext('isar', result: isarResult);
//       Isar isar = isarResult.value!;

//       final moodLogRepository = MoodLogRepository(isar);

//       // Calculate the start and end dates for the current month
//       final currentMonthStart = _startOfMonth(action.referenceDate);
//       final currentMonthEnd = _endOfMonth(action.referenceDate);

//       // Fetch average mood ratings for the current month
//       var currentMonthAverageMoodRatingsResult =
//           Result<Map<DateTime, double>>();
//       var scatterSpotsResult = Result<List<ScatterSpot>>();
//       yield Call(
//         moodLogRepository.getAverageMoodLogsForWeek,
//         args: [currentMonthStart, currentMonthEnd],
//         result: currentMonthAverageMoodRatingsResult,
//       );

//       print(
//           "currentMonthAverageMoodRatingsResult: $currentMonthAverageMoodRatingsResult");

//       final moodData = currentMonthAverageMoodRatingsResult.value!;
//       // Call(_calculateScatterSpots(moodData), result: scatterSpotsResult);

//       // print("scatterSpotsResult: $scatterSpotsResult");
//       // final scatterSpots = scatterSpotsResult.value!;

//       // print("scatterSpots: $scatterSpots");

//       scatterSpotsResult.value = await _calculateScatterSpots(moodData);

//       print("scatterSpotsResult: $scatterSpotsResult");
//       print("scatterSpots: ${scatterSpotsResult.value}");

//       // Dispatch success action with the average mood ratings and scatter spots
//       yield Put(MonthlyMoodReportFetchedSuccessAction(
//         moodData,
//         scatterSpotsResult.value!,
//       ));
//     }, Catch: (e, s) sync* {
//       print("Error fetching monthly mood report: $e");
//       yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
//     });
//   }

//   static Future<List<ScatterSpot>> _calculateScatterSpots(
//       Map<DateTime, double> moodData) async {
//     List<DateTime> dates = moodData.keys.toList();
//     final sleepData = await HealthDataFetcher.fetchHealthData(dates);
//     return _mapToScatterSpots(moodData, sleepData);
//   }

//   static List<ScatterSpot> _mapToScatterSpots(
//       Map<DateTime, double> moodData, List<HealthDataPoint> sleepData) {
//     final Map<DateTime, double> sleepMap = {};
//     for (final dataPoint in sleepData) {
//       final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
//           dataPoint.dateFrom.day);
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

//       if (sleepMap.containsKey(date)) {
//         sleepMap[date] = sleepMap[date]! + duration;
//       } else {
//         sleepMap[date] = duration;
//       }
//     }

//     final List<ScatterSpot> scatterSpots = [];
//     moodData.forEach((moodDate, moodValue) {
//       final sleepDate = moodDate.subtract(const Duration(days: 1));
//       final sleepDateOnly =
//           DateTime(sleepDate.year, sleepDate.month, sleepDate.day);
//       if (sleepMap.containsKey(sleepDateOnly)) {
//         final sleepValue = sleepMap[sleepDateOnly]!;
//         scatterSpots.add(ScatterSpot(
//           sleepValue,
//           moodValue,
//           radius: calculateRadius(moodValue),
//           color: Colors.blue.withOpacity(0.1 * moodValue),
//         ));
//       }
//     });

//     return scatterSpots;
//   }

//   static DateTime _startOfMonth(DateTime date) {
//     return DateTime(date.year, date.month, 1);
//   }

//   static DateTime _endOfMonth(DateTime date) {
//     var nextMonth = DateTime(date.year, date.month + 1, 1);
//     return nextMonth.subtract(const Duration(days: 1));
//   }
// }

// double calculateRadius(double mood) {
//   double minRadius = 1.0;
//   double maxRadius = 15.0;
//   return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
// }
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:isar/isar.dart';
// import 'package:redux_saga/redux_saga.dart';
// import 'package:teja/domain/redux/app_state.dart';
// import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
// import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
// import 'package:health/health.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:teja/presentation/profile/ui/sleep_service.dart';

// class MonthlyMoodReportSaga {
//   Iterable<void> saga() sync* {
//     yield TakeEvery(
//       _fetchMonthlyMoodReport,
//       pattern: FetchMonthlyMoodReportAction,
//     );
//   }

//   _fetchMonthlyMoodReport(
//       {required FetchMonthlyMoodReportAction action}) sync* {
//     yield Try(() sync* {
//       var isarResult = Result<Isar>();
//       yield GetContext('isar', result: isarResult);
//       Isar isar = isarResult.value!;

//       final moodLogRepository = MoodLogRepository(isar);

//       // Calculate the start and end dates for the current month
//       final currentMonthStart = _startOfMonth(action.referenceDate);
//       final currentMonthEnd = _endOfMonth(action.referenceDate);

//       // Fetch average mood ratings for the current month
//       var currentMonthAverageMoodRatingsResult =
//           Result<Map<DateTime, double>>();
//       yield Call(
//         moodLogRepository.getAverageMoodLogsForWeek,
//         args: [currentMonthStart, currentMonthEnd],
//         result: currentMonthAverageMoodRatingsResult,
//       );

//       print(
//           "currentMonthAverageMoodRatingsResult: $currentMonthAverageMoodRatingsResult");

//       final moodData = currentMonthAverageMoodRatingsResult.value!;

//       // Dispatch an intermediate action if necessary to indicate fetching of scatter spots
//       yield Put(FetchingScatterSpotsAction());

//       // Call the asynchronous function to calculate scatter spots
//       yield Call(_fetchScatterSpots, args: [moodData]);
//     }, Catch: (e, s) sync* {
//       print("Error fetching monthly mood report: $e");
//       yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
//     });
//   }

//   static Future<void> _fetchScatterSpots(Map<DateTime, double> moodData) async {
//     final scatterSpots = await _calculateScatterSpots(moodData);
//     // Dispatch success action with the calculated scatter spots
//     StoreProvider.of<AppState>(context).dispatch(
//       MonthlyMoodReportFetchedSuccessAction(moodData, scatterSpots),
//     );
//   }

//   static Future<List<ScatterSpot>> _calculateScatterSpots(
//       Map<DateTime, double> moodData) async {
//     List<DateTime> dates = moodData.keys.toList();
//     final sleepData = await HealthDataFetcher.fetchHealthData(dates);
//     return _mapToScatterSpots(moodData, sleepData);
//   }

//   static List<ScatterSpot> _mapToScatterSpots(
//       Map<DateTime, double> moodData, List<HealthDataPoint> sleepData) {
//     final Map<DateTime, double> sleepMap = {};
//     for (final dataPoint in sleepData) {
//       final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
//           dataPoint.dateFrom.day);
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

//       if (sleepMap.containsKey(date)) {
//         sleepMap[date] = sleepMap[date]! + duration;
//       } else {
//         sleepMap[date] = duration;
//       }
//     }

//     final List<ScatterSpot> scatterSpots = [];
//     moodData.forEach((moodDate, moodValue) {
//       final sleepDate = moodDate.subtract(const Duration(days: 1));
//       final sleepDateOnly =
//           DateTime(sleepDate.year, sleepDate.month, sleepDate.day);
//       if (sleepMap.containsKey(sleepDateOnly)) {
//         final sleepValue = sleepMap[sleepDateOnly]!;
//         scatterSpots.add(ScatterSpot(
//           sleepValue,
//           moodValue,
//           radius: calculateRadius(moodValue),
//           color: Colors.blue.withOpacity(0.1 * moodValue),
//         ));
//       }
//     });

//     return scatterSpots;
//   }

//   static DateTime _startOfMonth(DateTime date) {
//     return DateTime(date.year, date.month, 1);
//   }

//   static DateTime _endOfMonth(DateTime date) {
//     var nextMonth = DateTime(date.year, date.month + 1, 1);
//     return nextMonth.subtract(const Duration(days: 1));
//   }
// }

// double calculateRadius(double mood) {
//   double minRadius = 1.0;
//   double maxRadius = 15.0;
//   return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
// }
// import 'package:isar/isar.dart';
// import 'package:redux_saga/redux_saga.dart';
// import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
// import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
// import 'package:health/health.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:teja/presentation/profile/ui/sleep_service.dart';
// import 'package:teja/domain/redux/app_state.dart';
// import 'package:redux/redux.dart';

// class MonthlyMoodReportSaga {
//   Iterable<void> saga() sync* {
//     yield TakeEvery(
//       _fetchMonthlyMoodReport,
//       pattern: FetchMonthlyMoodReportAction,
//     );
//   }

//   _fetchMonthlyMoodReport(
//       {required FetchMonthlyMoodReportAction action}) sync* {
//     yield Try(() sync* {
//       var isarResult = Result<Isar>();
//       yield GetContext('isar', result: isarResult);
//       Isar isar = isarResult.value!;

//       final moodLogRepository = MoodLogRepository(isar);

//       // Calculate the start and end dates for the current month
//       final currentMonthStart = _startOfMonth(action.referenceDate);
//       final currentMonthEnd = _endOfMonth(action.referenceDate);

//       // Fetch average mood ratings for the current month
//       var currentMonthAverageMoodRatingsResult =
//           Result<Map<DateTime, double>>();
//       yield Call(
//         moodLogRepository.getAverageMoodLogsForWeek,
//         args: [currentMonthStart, currentMonthEnd],
//         result: currentMonthAverageMoodRatingsResult,
//       );

//       print(
//           "currentMonthAverageMoodRatingsResult: $currentMonthAverageMoodRatingsResult");

//       final moodData = currentMonthAverageMoodRatingsResult.value!;

//       // Dispatch an intermediate action if necessary to indicate fetching of scatter spots
//       yield Put(FetchingScatterSpotsAction());

//       // Call the asynchronous function to calculate scatter spots
//       var storeResult = Result<Store<AppState>>();
//       yield GetContext('store', result: storeResult);
//       Store<AppState> store = storeResult.value!;
//       yield Call(_fetchScatterSpots, args: [store, moodData]);
//     }, Catch: (e, s) sync* {
//       print("Error fetching monthly mood report: $e");
//       yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
//     });
//   }

//   static Future<void> _fetchScatterSpots(
//       Store<AppState> store, Map<DateTime, double> moodData) async {
//     final scatterSpots = await _calculateScatterSpots(moodData);
//     // Dispatch success action with the calculated scatter spots
//     store.dispatch(
//         MonthlyMoodReportFetchedSuccessAction(moodData, scatterSpots));
//   }

//   static Future<List<ScatterSpot>> _calculateScatterSpots(
//       Map<DateTime, double> moodData) async {
//     List<DateTime> dates = moodData.keys.toList();
//     final sleepData = await HealthDataFetcher.fetchHealthData(dates);
//     return _mapToScatterSpots(moodData, sleepData);
//   }

//   static List<ScatterSpot> _mapToScatterSpots(
//       Map<DateTime, double> moodData, List<HealthDataPoint> sleepData) {
//     final Map<DateTime, double> sleepMap = {};
//     for (final dataPoint in sleepData) {
//       final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
//           dataPoint.dateFrom.day);
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

//       if (sleepMap.containsKey(date)) {
//         sleepMap[date] = sleepMap[date]! + duration;
//       } else {
//         sleepMap[date] = duration;
//       }
//     }

//     final List<ScatterSpot> scatterSpots = [];
//     moodData.forEach((moodDate, moodValue) {
//       final sleepDate = moodDate.subtract(const Duration(days: 1));
//       final sleepDateOnly =
//           DateTime(sleepDate.year, sleepDate.month, sleepDate.day);
//       if (sleepMap.containsKey(sleepDateOnly)) {
//         final sleepValue = sleepMap[sleepDateOnly]!;
//         scatterSpots.add(ScatterSpot(
//           sleepValue,
//           moodValue,
//           radius: calculateRadius(moodValue),
//           color: Colors.blue.withOpacity(0.1 * moodValue),
//         ));
//       }
//     });

//     return scatterSpots;
//   }

//   static DateTime _startOfMonth(DateTime date) {
//     return DateTime(date.year, date.month, 1);
//   }

//   static DateTime _endOfMonth(DateTime date) {
//     var nextMonth = DateTime(date.year, date.month + 1, 1);
//     return nextMonth.subtract(const Duration(days: 1));
//   }
// }

// double calculateRadius(double mood) {
//   double minRadius = 1.0;
//   double maxRadius = 15.0;
//   return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
// }

// import 'package:isar/isar.dart';
// import 'package:redux_saga/redux_saga.dart';
// import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
// import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
// import 'package:health/health.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:teja/presentation/profile/ui/sleep_service.dart';

// class MonthlyMoodReportSaga {
//   Iterable<void> saga() sync* {
//     yield TakeEvery(
//       _fetchMonthlyMoodReport,
//       pattern: FetchMonthlyMoodReportAction,
//     );
//   }

//   _fetchMonthlyMoodReport(
//       {required FetchMonthlyMoodReportAction action}) sync* {
//     yield Try(() sync* {
//       var isarResult = Result<Isar>();
//       yield GetContext('isar', result: isarResult);
//       Isar? isar = isarResult.value;

//       if (isar == null) {
//         throw Exception("Isar context is null");
//       }

//       final moodLogRepository = MoodLogRepository(isar);

//       // Calculate the start and end dates for the current month
//       final currentMonthStart = _startOfMonth(action.referenceDate);
//       final currentMonthEnd = _endOfMonth(action.referenceDate);

//       // Fetch average mood ratings for the current month
//       var currentMonthAverageMoodRatingsResult =
//           Result<Map<DateTime, double>>();
//       yield Call(
//         moodLogRepository.getAverageMoodLogsForWeek,
//         args: [currentMonthStart, currentMonthEnd],
//         result: currentMonthAverageMoodRatingsResult,
//       );

//       if (currentMonthAverageMoodRatingsResult.value == null) {
//         throw Exception("Failed to fetch mood data");
//       }

//       final moodData = currentMonthAverageMoodRatingsResult.value!;

//       // Dispatch an intermediate action if necessary to indicate fetching of scatter spots
//       yield Put(FetchingScatterSpotsAction());

//       // Call the asynchronous function to calculate scatter spots

//       yield Call(_fetchScatterSpots, args: [moodData]);
//     }, Catch: (e, s) sync* {
//       print("Error fetching monthly mood report: $e");
//       yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
//     });
//   }

//   static Future<void> _fetchScatterSpots(Map<DateTime, double> moodData) async {
//     final scatterSpots = await _calculateScatterSpots(moodData);
//     print("scatterSpots: $scatterSpots");
//     // Dispatch success action with the calculated scatter spots
//     MonthlyMoodReportFetchedSuccessAction(moodData, scatterSpots);
//   }

//   static Future<List<ScatterSpot>> _calculateScatterSpots(
//       Map<DateTime, double> moodData) async {
//     List<DateTime> dates = moodData.keys.toList();
//     final sleepData = await HealthDataFetcher.fetchHealthData(dates);
//     return _mapToScatterSpots(moodData, sleepData);
//   }

//   static List<ScatterSpot> _mapToScatterSpots(
//       Map<DateTime, double> moodData, List<HealthDataPoint> sleepData) {
//     final Map<DateTime, double> sleepMap = {};
//     for (final dataPoint in sleepData) {
//       final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
//           dataPoint.dateFrom.day);
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

//       if (sleepMap.containsKey(date)) {
//         sleepMap[date] = sleepMap[date]! + duration;
//       } else {
//         sleepMap[date] = duration;
//       }
//     }

//     final List<ScatterSpot> scatterSpots = [];
//     moodData.forEach((moodDate, moodValue) {
//       final sleepDate = moodDate.subtract(const Duration(days: 1));
//       final sleepDateOnly =
//           DateTime(sleepDate.year, sleepDate.month, sleepDate.day);
//       if (sleepMap.containsKey(sleepDateOnly)) {
//         final sleepValue = sleepMap[sleepDateOnly]!;
//         scatterSpots.add(ScatterSpot(
//           sleepValue,
//           moodValue,
//           radius: calculateRadius(moodValue),
//           color: Colors.blue.withOpacity(0.1 * moodValue),
//         ));
//       }
//     });

//     return scatterSpots;
//   }

//   static DateTime _startOfMonth(DateTime date) {
//     return DateTime(date.year, date.month, 1);
//   }

//   static DateTime _endOfMonth(DateTime date) {
//     var nextMonth = DateTime(date.year, date.month + 1, 1);
//     return nextMonth.subtract(const Duration(days: 1));
//   }
// }

// double calculateRadius(double mood) {
//   double minRadius = 1.0;
//   double maxRadius = 15.0;
//   return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
// }

import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:health/health.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:teja/presentation/profile/ui/sleep_service.dart';

class MonthlyMoodReportSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _fetchMonthlyMoodReport,
      pattern: FetchMonthlyMoodReportAction,
    );
  }

  _fetchMonthlyMoodReport(
      {required FetchMonthlyMoodReportAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar? isar = isarResult.value;

      if (isar == null) {
        throw Exception("Isar context is null");
      }

      final moodLogRepository = MoodLogRepository(isar);

      // Calculate the start and end dates for the current month
      final currentMonthStart = _startOfMonth(action.referenceDate);
      final currentMonthEnd = _endOfMonth(action.referenceDate);

      // Fetch average mood ratings for the current month
      var currentMonthAverageMoodRatingsResult =
          Result<Map<DateTime, double>>();
      yield Call(
        moodLogRepository.getAverageMoodLogsForWeek,
        args: [currentMonthStart, currentMonthEnd],
        result: currentMonthAverageMoodRatingsResult,
      );

      if (currentMonthAverageMoodRatingsResult.value == null) {
        throw Exception("Failed to fetch mood data");
      }

      final moodData = currentMonthAverageMoodRatingsResult.value!;

      // Dispatch an intermediate action if necessary to indicate fetching of scatter spots
      yield Put(FetchingScatterSpotsAction());

      // Call the asynchronous function to calculate scatter spots
      var scatterSpotsResult = Result<List<ScatterSpot>>();
      yield Call(_fetchScatterSpots,
          args: [moodData], result: scatterSpotsResult);

      final scatterSpots = scatterSpotsResult.value;

      print("scatterSpots: $scatterSpots");
      if (scatterSpots == null) {
        throw Exception("Failed to calculate scatter spots");
      }

      // Dispatch success action with the calculated scatter spots
      yield Put(MonthlyMoodReportFetchedSuccessAction(moodData, scatterSpots));
    }, Catch: (e, s) sync* {
      print("Error fetching monthly mood report: $e");
      yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
    });
  }

  static Future<List<ScatterSpot>> _fetchScatterSpots(
      Map<DateTime, double> moodData) async {
    return await _calculateScatterSpots(moodData);
  }

  static Future<List<ScatterSpot>> _calculateScatterSpots(
      Map<DateTime, double> moodData) async {
    List<DateTime> dates = moodData.keys.toList();
    final sleepData = await HealthDataFetcher.fetchHealthData(dates);
    return _mapToScatterSpots(moodData, sleepData);
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
        scatterSpots.add(ScatterSpot(
          sleepValue,
          moodValue,
          radius: calculateRadius(moodValue),
          color: Colors.blue.withOpacity(0.1 * moodValue),
        ));
      }
    });

    return scatterSpots;
  }

  static DateTime _startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime _endOfMonth(DateTime date) {
    var nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1));
  }
}

double calculateRadius(double mood) {
  double minRadius = 1.0;
  double maxRadius = 15.0;
  return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
}
