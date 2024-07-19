import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthDataFetcher {
  static Future<List<HealthDataPoint>> fetchSleepData(List<DateTime> dates) async {
    Health().configure(useHealthConnectIfAvailable: true);
    final types = [HealthDataType.SLEEP_IN_BED]; // Define the types you want to fetch
    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions = await Health().hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    bool authorized = false;

    if (!hasPermissions) {
      try {
        authorized = await Health().requestAuthorization(types, permissions: permissions);
      } catch (error) {
        throw Exception('Authorization error');
      }
    }

    if (authorized) {
      try {
        List<HealthDataPoint> healthData = [];
        for (DateTime date in dates) {
          DateTime startTime = DateTime(date.year, date.month, date.day).subtract(const Duration(days: 1));
          DateTime endTime = DateTime(date.year, date.month, date.day);

          List<HealthDataPoint> dailyHealthData = await Health().getHealthDataFromTypes(
            types: types,
            startTime: startTime,
            endTime: endTime,
          );
          healthData.addAll(dailyHealthData);
        }

        return healthData;
      } catch (e) {
        throw Exception('Error fetching sleep data');
      }
    } else {
      throw Exception('Permission not granted');
    }
  }

  static Future<List<HealthDataPoint>> fetchStepsData(List<DateTime> dates) async {
    Health().configure(useHealthConnectIfAvailable: true);
    final types = [HealthDataType.STEPS]; // Define the types you want to fetch
    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions = await Health().hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    bool authorized = false;

    if (!hasPermissions) {
      try {
        authorized = await Health().requestAuthorization(types, permissions: permissions);
      } catch (error) {
        throw Exception('Authorization error');
      }
    }

    if (authorized) {
      try {
        List<HealthDataPoint> healthData = [];
        for (DateTime date in dates) {
          DateTime startTime = DateTime(date.year, date.month, date.day).subtract(const Duration(days: 1));
          DateTime endTime = DateTime(date.year, date.month, date.day);

          List<HealthDataPoint> dailyHealthData = await Health().getHealthDataFromTypes(
            types: types,
            startTime: startTime,
            endTime: endTime,
          );
          healthData.addAll(dailyHealthData);
        }
        return healthData;
      } catch (e) {
        throw Exception('Error fetching steps data');
      }
    } else {
      throw Exception('Permission not granted');
    }
  }
}
