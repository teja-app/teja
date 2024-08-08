import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'dart:io' show Platform;

import 'package:teja/shared/storage/secure_storage.dart';

Future<void> setPosthogContext() async {
  // Get device information
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var deviceData;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceData = androidInfo.model; // Or any other relevant info
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceData = iosInfo.model;
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
    Posthog().identify(
      userId: userId,
      userProperties: {
        'device': {
          'info': deviceData,
          'os': Platform.operatingSystem,
        },
        'app': {
          'version': appVersion,
        },
        'network': {
          'status': networkStatus,
        },
        // Add more context data as needed
      },
    );
  }
  // Set Posthog context
}
