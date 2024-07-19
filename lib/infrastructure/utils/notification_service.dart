import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import 'dart:io' show Platform;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initializes the notification service
  Future<void> initialize() async {
    await _configureTimeZone();

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: selectNotification);
    } catch (e) {
      // Handle initialization failure
    }
  }

  Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {}

  void selectNotification(NotificationResponse? payload) {
    if (payload != null) {
    } else {}
    // Get.to(() => NotiFiedPage(label: '$payload'));
  }

  /// Requests permission for notifications on iOS
  Future<void> requestIOSPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<int> getUniqueNotificationId() async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    int newId = 100; // Starting base value
    while (pendingNotifications.any((notification) => notification.id == newId)) {
      newId++;
    }
    return newId;
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
    String channelId = 'default_channel_id',
    String channelName = 'Default Channel',
    String channelDescription = 'Default channel description',
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exact,
  }) async {
    int uniqueId = await getUniqueNotificationId(); // Get a unique ID for the notification

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        uniqueId, // Use the unique ID
        title,
        body,
        _nextInstanceOfSpecificTime(hour, minute),
        NotificationDetails(
          android: AndroidNotificationDetails(channelId, channelName),
          iOS: const DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: scheduleMode,
      );
    } catch (e) {}
  }

  /// Cancels a scheduled notification
  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      // Handle cancellation failure
    }
  }

  // Configures the timezone settings

  Future<void> _configureTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterTimezone.getLocalTimezone(); // Get local timezone using flutter_timezone
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  /// Calculates the next instance of a specific time
  tz.TZDateTime _nextInstanceOfSpecificTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) scheduledDate = scheduledDate.add(const Duration(days: 1));
    return scheduledDate;
  }
}
