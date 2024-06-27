import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/domain/redux/permission/permission_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:health/health.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:teja/infrastructure/service/sleep_service.dart';

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
      yield Put(MonthlyMoodReportFetchInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar? isar = isarResult.value;

      if (isar == null) {
        throw Exception("Isar context is null");
      }

      final moodLogRepository = MoodLogRepository(isar);

      // Calculate the start and end dates for the past 30 days
      final startDate = _startOfLast30Days(action.referenceDate);
      final endDate = action.referenceDate;

      // Fetch average mood ratings for the past 30 days
      var averageMoodRatingsResult = Result<Map<DateTime, double>>();
      yield Call(
        moodLogRepository.getAverageMoodLogsForWeek,
        args: [startDate, endDate],
        result: averageMoodRatingsResult,
      );

      if (averageMoodRatingsResult.value == null) {
        throw Exception("Failed to fetch mood data");
      }

      final moodData = averageMoodRatingsResult.value!;
      print("00000009ssdijdnskndksndmsnmdnmdsnmsd");
      print("moodData: $moodData");

      if (moodData.isNotEmpty) {
        yield Put(AddPermissionAction("MOOD_MONTHLY"));
      }
      if (moodData.isEmpty) {
        yield Put(RemovePermissionAction("MOOD_MONTHLY"));
      }

      // Dispatch an intermediate action if necessary to indicate fetching of scatter spots
      yield Put(FetchingScatterSpotsAction());

      // Call the asynchronous function to calculate scatter spots
      var scatterSpotsResult = Result<List<ScatterSpot>>();
      yield Call(_fetchScatterSpots,
          args: [moodData], result: scatterSpotsResult);

      final scatterSpots = scatterSpotsResult.value;

      print("scatterSpots: $scatterSpots");
      if (scatterSpots == null) {
        yield Put(RemovePermissionAction(SLEEP));
        throw Exception("Failed to calculate scatter spots");
      }

      if (scatterSpots.isNotEmpty) {
        yield Put(AddPermissionAction(SLEEP));
      }

      var scatterStepSpotsResult = Result<List<ScatterSpot>>();
      yield Call(_fetchStepsScatterSpots,
          args: [moodData], result: scatterStepSpotsResult);

      final scatterStepSpots = scatterStepSpotsResult.value;

      print("scatterStepSpots: $scatterStepSpots");
      if (scatterStepSpots == null) {
        yield Put(RemovePermissionAction(ACTIVITY_MONTHLY));
        throw Exception("Failed to calculate scatter spots");
      }

      if (scatterStepSpots.isNotEmpty) {
        yield Put(AddPermissionAction(ACTIVITY_MONTHLY));
      }

      // Dispatch success action with the calculated scatter spots
      yield Put(MonthlyMoodReportFetchedSuccessAction(
          moodData, scatterSpots, scatterStepSpots));
    }, Catch: (e, s) sync* {
      print("Error fetching monthly mood report: $e");
      yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
    });
  }

  static Future<List<ScatterSpot>> _fetchScatterSpots(
      Map<DateTime, double> moodData) async {
    return await _calculateScatterSpots(moodData);
  }

  static Future<List<ScatterSpot>> _fetchStepsScatterSpots(
      Map<DateTime, double> moodData) async {
    return await _calculateStepScatterSpots(moodData);
  }

  static Future<List<ScatterSpot>> _calculateScatterSpots(
      Map<DateTime, double> moodData) async {
    List<DateTime> dates = moodData.keys.toList();
    final sleepData = await HealthDataFetcher.fetchSleepData(dates);
    return _mapToScatterSpots(moodData, sleepData);
  }

  static Future<List<ScatterSpot>> _calculateStepScatterSpots(
      Map<DateTime, double> moodData) async {
    List<DateTime> dates = moodData.keys.toList();
    final stepData = await HealthDataFetcher.fetchStepsData(dates);
    return _mapToStepScatterSpots(moodData, stepData);
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
          radius: calculateRadius(3),
          color: Colors.blue.withOpacity(0.3),
        ));
      }
    });

    return scatterSpots;
  }

  static List<ScatterSpot> _mapToStepScatterSpots(
      Map<DateTime, double> moodData, List<HealthDataPoint> stepData) {
    final Map<DateTime, double> stepMap = {};

    for (final dataPoint in stepData) {
      final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
          dataPoint.dateFrom.day);
      final value = dataPoint.value;
      double stepsCount;

      final valueString = value.toString();
      if (valueString.contains('numericValue')) {
        final numericValueString = valueString.split('numericValue:')[1].trim();
        stepsCount = double.parse(numericValueString);
      } else {
        continue;
      }

      stepMap[date] = stepsCount;
    }

    final List<ScatterSpot> scatterSpots = [];
    moodData.forEach((moodDate, moodValue) {
      final stepsDate = moodDate.subtract(const Duration(days: 1));
      final stepsDateOnly =
          DateTime(stepsDate.year, stepsDate.month, stepsDate.day);
      if (stepMap.containsKey(stepsDateOnly)) {
        final stepsCount = stepMap[stepsDateOnly]!;
        scatterSpots.add(ScatterSpot(
          stepsCount,
          moodValue,
          radius: calculateRadius(3),
          color: Colors.blue.withOpacity(0.3),
        ));
      }
    });

    return scatterSpots;
  }

  static DateTime _startOfLast30Days(DateTime date) {
    return date.subtract(const Duration(days: 30));
  }
}

double calculateRadius(double mood) {
  double minRadius = 1.0;
  double maxRadius = 15.0;
  return minRadius + (mood - 1) * (maxRadius - minRadius) / (5 - 1);
}
