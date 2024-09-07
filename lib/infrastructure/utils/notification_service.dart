import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:teja/shared/helpers/logger.dart';

import 'dart:io' show Platform;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _configureTimeZone();

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
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

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {}

  void selectNotification(NotificationResponse? payload) {
    if (payload != null) {
    } else {}
    // Navigate to the desired page
  }

  Future<void> requestIOSPermissions() async {
    if (Platform.isIOS) {
      logger.i("resolvePlatformSpecificImplementation");
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
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
    while (
        pendingNotifications.any((notification) => notification.id == newId)) {
      newId++;
    }
    return newId;
  }

  Future<void> scheduleNotification({
    required int uniqueId,
    required String title,
    required String body,
    required int hour,
    required int minute,
    int daysAhead = 30,
    String channelId = 'default_channel_id',
    String channelName = 'Default Channel',
    String channelDescription = 'Default channel description',
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exact,
    bool isTestMode = false,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < daysAhead; i++) {
      final int currentNotificationId = uniqueId + i;

      try {
        tz.TZDateTime scheduledTime;
        if (isTestMode) {
          scheduledTime = now.add(Duration(seconds: 10 * (i + 1)));
        } else {
          scheduledTime = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day + i,
            hour,
            minute,
          );

          // If the calculated time is in the past, schedule it for the next day
          if (scheduledTime.isBefore(now)) {
            scheduledTime = scheduledTime.add(const Duration(days: 1));
          }
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          currentNotificationId,
          title,
          body,
          scheduledTime,
          NotificationDetails(
            android: AndroidNotificationDetails(channelId, channelName),
            iOS: const DarwinNotificationDetails(),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: scheduleMode,
        );
      } catch (e) {
        // Handle scheduling error
        print('Error scheduling notification: $e');
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      // Handle cancellation failure
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      for (int i = 0; i < 30; i++) {
        await flutterLocalNotificationsPlugin.cancel(id + i);
      }
    } catch (e) {
      // Handle cancellation failure
    }
  }

  Future<void> refreshDailyNotifications({
    required int uniqueId,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Cancel all existing notifications
    await cancelAllNotifications();

    // Schedule notifications for the next 30 days
    await scheduleNotification(
      uniqueId: uniqueId,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
      // daysAhead: 30,
    );
  }

  Future<void> _configureTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  tz.TZDateTime _nextInstanceOfSpecificTime(int hour, int minute,
      {int daysAhead = 0}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day + daysAhead, hour, minute);
    if (scheduledDate.isBefore(now))
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    return scheduledDate;
  }
}
