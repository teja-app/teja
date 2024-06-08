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
      yield Put(MonthlyMoodReportFetchInProgressAction());
      List<Map<String, bool>> checklist = [
        {"Sleep data exists": false},
        {"Mood data exists": false},
      ];

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
      checklist[2]["Mood data exists"] = moodData.isNotEmpty;

      // Dispatch an intermediate action if necessary to indicate fetching of scatter spots
      yield Put(FetchingScatterSpotsAction());

      // Call the asynchronous function to calculate scatter spots
      var scatterSpotsResult = Result<List<ScatterSpot>>();
      yield Call(_fetchScatterSpots,
          args: [moodData, checklist], result: scatterSpotsResult);

      final scatterSpots = scatterSpotsResult.value;

      print("scatterSpots: $scatterSpots");
      if (scatterSpots == null) {
        throw Exception("Failed to calculate scatter spots");
      }
      checklist[1]["Sleep data exists"] = scatterSpots.isNotEmpty;

      // Dispatch success action with the calculated scatter spots
      yield Put(MonthlyMoodReportFetchedSuccessAction(
          moodData, scatterSpots, checklist));
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
