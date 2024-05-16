// import 'package:flutter/material.dart';
// import 'package:redux/redux.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
// url_launcher
// import 'package:teja/domain/redux/app_state.dart';

// @immutable
// abstract class HealthDataAction {}

// @immutable
// class FetchHealthDataAction extends HealthDataAction {}

// @immutable
// class HealthDataFetchInProgressAction extends HealthDataAction {}

// @immutable
// class HealthDataFetchedSuccessAction extends HealthDataAction {
//   final List<HealthDataPoint> healthDataList;

//   HealthDataFetchedSuccessAction(this.healthDataList);
// }

// @immutable
// class HealthDataFetchFailedAction extends HealthDataAction {
//   final String errorMessage;

//   HealthDataFetchFailedAction(this.errorMessage);
// }

// // Define a function to fetch health data asynchronously
// void fetchHealthData(Store<AppState> store) async {
//   store.dispatch(HealthDataFetchInProgressAction());

//   try {
//     final now = DateTime.now();
//     final yesterday = now.subtract(const Duration(days: 30));
//     final types = [HealthDataType.SLEEP_IN_BED]; // Define the types you want to fetch

//     final permissions = types.map((e) => HealthDataAccess.READ).toList();

//     bool? hasPermissions = await Health().hasPermissions(types, permissions: permissions);

//     if (!hasPermissions!) {
//       hasPermissions = await Health().requestAuthorization(types, permissions: permissions);
//     }

//     if (hasPermissions) {
//       List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
//         types: types,
//         startTime: yesterday,
//         endTime: now,
//       );

//       store.dispatch(HealthDataFetchedSuccessAction(healthData));

//     } else {
//       store.dispatch(HealthDataFetchFailedAction('Permission not granted'));
//     }
//   } catch (e) {
//     store.dispatch(HealthDataFetchFailedAction(e.toString()));
//   }
// }
// class HealthDataFetcher {
//   static Future<List<HealthDataPoint>> fetchHealthData() async {
//     final now = DateTime.now();
//     final yesterday = now.subtract(const Duration(days: 30));
//     final types = [
//       HealthDataType.SLEEP_IN_BED
//     ]; // Define the types you want to fetch

//     bool hasPermissions;
//     // print("permissions: $permissions");
//     // bool? hasPermissions =
//     //     await Health().hasPermissions(types, permissions: permissions);
//     // print("hasPermissions: $hasPermissions");

//     hasPermissions = await Health().requestAuthorization(types);

//     print("hasPermissions: $hasPermissions");
//     // bool hasPermissions =
//     //     await Health().requestAuthorization(types, permissions: permissions);

//     if (!hasPermissions) {
//       // await Health().revokePermissions();
//       await openAppSettings();

//       // hasPermissions = await Health().requestAuthorization(types);
//       // hasPermissions = await Health().requestAuthorization(types);
//     }

//     if (hasPermissions) {
//       List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
//         types: types,
//         startTime: yesterday,
//         endTime: now,
//       );
//       print("Health data: $healthData");
//       return healthData;
//     } else {
//       throw Exception('Permission not granted');
//     }
//   }
// }
// class HealthDataFetcher {
//   static Future<List<HealthDataPoint>> fetchHealthData() async {
//     // final HealthFactory health = HealthFactory();

//     Health().configure(useHealthConnectIfAvailable: true);
//     final now = DateTime.now();
//     final yesterday = now.subtract(const Duration(days: 30));
//     final types = [
//       HealthDataType.SLEEP_IN_BED
//     ]; // Define the types you want to fetch
//     final permissions = types.map((e) => HealthDataAccess.READ).toList();

//     await Permission.activityRecognition.request();
//     await Permission.location.request();

//     // Request permissions
//     bool? hasPermissions =
//         await Health().hasPermissions(types, permissions: permissions);

//     hasPermissions = false;

//     bool authorized = false;
//     if (!hasPermissions) {
//       try {
//         authorized = await Health()
//             .requestAuthorization(types, permissions: permissions);
//       } catch (error) {
//         print("Exception in authorize: $error");
//       }
//     }

//     if (authorized) {
//       try {
//         List<HealthDataPoint> healthData =
//             await Health().getHealthDataFromTypes(
//           types: types,
//           startTime: yesterday,
//           endTime: now,
//         );
//         return healthData;
//       } catch (e) {
//         // Handle error while fetching health data
//         print("Error fetching health data: $e");
//         throw Exception('Error fetching health data');
//       }
//     } else {
//       // Permissions not granted even after prompting the user
//       throw Exception('Permission not granted');
//     }
//   }
// }
class HealthDataFetcher {
  static Future<List<HealthDataPoint>> fetchHealthData(
      List<DateTime> dates) async {
    Health().configure(useHealthConnectIfAvailable: true);
    final types = [
      HealthDataType.SLEEP_IN_BED
    ]; // Define the types you want to fetch
    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    bool authorized = false;

    if (!hasPermissions) {
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }

    if (authorized) {
      try {
        List<HealthDataPoint> healthData = [];
        for (DateTime date in dates) {
          DateTime startTime = DateTime(date.year, date.month, date.day)
              .subtract(const Duration(days: 1));
          DateTime endTime = DateTime(date.year, date.month, date.day);

          List<HealthDataPoint> dailyHealthData =
              await Health().getHealthDataFromTypes(
            types: types,
            startTime: startTime,
            endTime: endTime,
          );
          healthData.addAll(dailyHealthData);
        }
        return healthData;
      } catch (e) {
        print("Error fetching health data: $e");
        throw Exception('Error fetching health data');
      }
    } else {
      throw Exception('Permission not granted');
    }
  }
}
