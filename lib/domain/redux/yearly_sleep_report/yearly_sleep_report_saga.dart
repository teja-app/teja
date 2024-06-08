import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_actions.dart';
import 'package:teja/presentation/profile/ui/sleep_service.dart';
import 'package:health/health.dart';

class YearlySleepReportSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _fetchYearlySleepReport,
      pattern: FetchYearlySleepReportAction,
    );
  }

  _fetchYearlySleepReport(
      {required FetchYearlySleepReportAction action}) sync* {
    yield Try(() sync* {
      yield Put(YearlySleepReportFetchInProgressAction());
      List<Map<String, bool>> checklist = [
        {"Sleep data exists": false},
      ];

      final startOfYear = DateTime(action.referenceDate.year, 1, 1);
      final endOfYear = DateTime(action.referenceDate.year, 12, 31);

      final dates = _getDatesInRange(startOfYear, endOfYear);

      var healthDataResult = Result<List<HealthDataPoint>>();
      yield Call(HealthDataFetcher.fetchHealthData,
          args: [dates], result: healthDataResult);

      final sleepData = healthDataResult.value;
      if (sleepData == null) {
        throw Exception("Failed to fetch sleep data");
      }
      checklist[0]["Sleep data exists"] = sleepData.isNotEmpty;

      final cumulativeSleepData = _calculateCumulativeSleepData(sleepData);

      yield Put(YearlySleepReportFetchedSuccessAction(
          cumulativeSleepData, checklist));
    }, Catch: (e, s) sync* {
      yield Put(YearlySleepReportFetchFailedAction(e.toString()));
    });
  }

  List<DateTime> _getDatesInRange(DateTime start, DateTime end) {
    final List<DateTime> dates = [];
    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }

  Map<DateTime, int> _calculateCumulativeSleepData(
      List<HealthDataPoint> sleepData) {
    final Map<DateTime, int> cumulativeSleepMap = {};
    for (final dataPoint in sleepData) {
      final date = DateTime(dataPoint.dateFrom.year, dataPoint.dateFrom.month,
          dataPoint.dateFrom.day);
      final value = dataPoint.value;

      int duration;

      final valueString = value.toString();
      if (valueString.contains('numericValue')) {
        final numericValueString = valueString.split('numericValue:')[1].trim();
        duration = (double.parse(numericValueString) * 60)
            .toInt(); // Convert to minutes
      } else if (valueString.contains('instantValue')) {
        final instantValueString = valueString.split('instantValue:')[1].trim();
        final instantValue = DateTime.parse(instantValueString);
        duration = instantValue
            .difference(DateTime.fromMillisecondsSinceEpoch(0))
            .inMinutes
            .toInt();
      } else {
        continue;
      }

      if (cumulativeSleepMap.containsKey(date)) {
        cumulativeSleepMap[date] = cumulativeSleepMap[date]! + duration;
      } else {
        cumulativeSleepMap[date] = duration;
      }
    }
    return cumulativeSleepMap;
  }
}
