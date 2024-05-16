// sleep_service.dart
import 'package:health/health.dart';

class SleepService {
  static final HealthFactory _healthFactory = HealthFactory();

  static Future<List<HealthDataPoint>> getSleepData(DateTime startDate, DateTime endDate) async {
    final types = [HealthDataType.SLEEP_IN_BED];

    final permissions = [
      HealthDataAccess.READ,
    ];

    final permissionStatus = await _healthFactory.requestAuthorization(types, permissions: permissions);

    if (permissionStatus.isSuccess) {
      final sleepData = await _healthFactory.getHealthDataFromTypes(startDate, endDate, types);
      return _processRawSleepData(sleepData);
    } else {
      throw Exception('Permission not granted');
    }
  }

  static List<HealthDataPoint> _processRawSleepData(List<HealthDataPoint> rawSleepData) {
    final Map<DateTime, List<HealthDataPoint>> sleepDataMap = {};

    for (var sleepEntry in rawSleepData) {
      final startDate = DateTime(sleepEntry.dateFrom.year, sleepEntry.dateFrom.month, sleepEntry.dateFrom.day);
      final endDate = DateTime(sleepEntry.dateTo.year, sleepEntry.dateTo.month, sleepEntry.dateTo.day);

      if (startDate == endDate) {
        sleepDataMap[startDate] ??= [];
        sleepDataMap[startDate]!.add(sleepEntry);
      } else {
        final startDayDuration = DateTime(sleepEntry.dateTo.year, sleepEntry.dateTo.month, sleepEntry.dateTo.day)
            .difference(sleepEntry.dateFrom);
        final endDayDuration = sleepEntry.dateTo.difference(
            DateTime(sleepEntry.dateTo.year, sleepEntry.dateTo.month, sleepEntry.dateTo.day));

        sleepDataMap[startDate] ??= [];
        sleepDataMap[startDate]!.add(HealthDataPoint(
          dateFrom: sleepEntry.dateFrom,
          dateTo: sleepEntry.dateFrom.add(startDayDuration),
          value: HealthDataPoint.fromJson(sleepEntry.toJson()).value,
          dataType: sleepEntry.dataType,
          deviceId: sleepEntry.deviceId,
          unit: sleepEntry.unit,
        ));

        sleepDataMap[endDate] ??= [];
        sleepDataMap[endDate]!.add(HealthDataPoint(
          dateFrom: DateTime(sleepEntry.dateTo.year, sleepEntry.dateTo.month, sleepEntry.dateTo.day),
          dateTo: sleepEntry.dateTo,
          value: HealthDataPoint.fromJson(sleepEntry.toJson()).value,
          dataType: sleepEntry.dataType,
          deviceId: sleepEntry.deviceId,
          unit: sleepEntry.unit,
        ));
      }
    }

    final List<HealthDataPoint> processedSleepData = [];

    sleepDataMap.forEach((date, sleepEntries) {
      final totalSleepDuration = sleepEntries.fold(0.0, (sum, entry) => sum + entry.value);
      final avgSleepEntry = HealthDataPoint(
        dateFrom: DateTime(date.year, date.month, date.day),
        dateTo: DateTime(date.year, date.month, date.day, 23, 59, 59),
        value: totalSleepDuration,
        dataType: HealthDataType.SLEEP_IN_BED,
        deviceId: '',
        unit: 'hour',
      );
      processedSleepData.add(avgSleepEntry);
    });

    return processedSleepData;
  }
}
