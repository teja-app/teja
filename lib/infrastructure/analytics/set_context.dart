// lib/infrastructure/analytics/set_context.dart

import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:teja/shared/storage/secure_storage.dart';
import 'package:teja/infrastructure/analytics/analytics_service.dart';

Future<void> setAnalyticsContext() async {
  final analyticsService = AnalyticsService();

  // Get device information
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceData;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceData = androidInfo.model;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceData = iosInfo.model;
  } else {
    deviceData = 'Unknown';
  }

  // Get app version
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;

  // Get network information
  var connectivityResult = await (Connectivity().checkConnectivity());
  String networkStatus = connectivityResult.toString();

  final SecureStorage secureStorage = SecureStorage();
  final userId = await secureStorage.readUserId();

  if (userId != null) {
    analyticsService.identify(
      userId,
      {
        'device': {
          'info': deviceData,
          'os': Platform.operatingSystem,
        } as Object,
        'app': {
          'version': appVersion,
        } as Object,
        'network': {
          'status': networkStatus,
        } as Object,
      },
    );
  }
}
