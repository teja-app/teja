import 'dart:io';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/infrastructure/database/hive_collections/notification_time_slot.dart';
import 'package:teja/infrastructure/database/hive_collections/user_preference.dart';
import 'package:teja/infrastructure/utils/notification_service.dart';
import 'package:teja/infrastructure/utils/share_handler_service.dart';
import 'package:teja/infrastructure/utils/time_storage_helper.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/store.dart';
import 'package:teja/infrastructure/constants/notification_types.dart';
import 'package:teja/config/open_cbl.dart';

final notificationService = NotificationService();
final shareHandler = ShareHandlerService();

Future<Store<AppState>> configureCommonDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Couchbase Lite before opening the database
  await CouchbaseLiteFlutter.init();

  // Initialize Couchbase Lite database
  final cblDb = await openCouchbaseLiteDatabase();
  logger.i("Couchbase Lite Database Instance is ready");

  await notificationService.initialize();
  logger.i("Notification Service Connected");

  if (Platform.isIOS) {
    logger.i("Notification Service Connected on iOS");
    await notificationService.requestIOSPermissions();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(TimeSlotAdapter());
  Hive.registerAdapter(UserPreferenceAdapter());
  await Hive.openBox(TimeSlot.boxKey);
  await Hive.openBox(UserPreference.boxKey);

  final store = await createStore(cblDb);
  logger.i("Connected to local data store");

  await notificationService.cancelAllNotifications();
  await handleNotificationInitialize(notificationService);
  await shareHandler.init();
  logger.i("Share Handler Service Connected");

  return store;
}


Future<void> handleNotificationInitialize(NotificationService notificationService) async {
  final TimeStorage timeStorage = TimeStorage();

  // Retrieve saved times and statuses
  final Map<String, TimeOfDay> timeSlots = await timeStorage.getAllTimeSlots();
  final Map<String, bool> enabledStatuses = await timeStorage.getEnabledStatuses();

  // Default settings
  final Map<String, TimeOfDay> defaultTimeSlots = {
    NotificationType.morningKickstart: const TimeOfDay(hour: 9, minute: 0),
    NotificationType.eveningWindDown: const TimeOfDay(hour: 21, minute: 0),
    NotificationType.focusReminder: const TimeOfDay(hour: 14, minute: 30),
    NotificationType.journalingCue: const TimeOfDay(hour: 12, minute: 0),
  };

  // Schedule or cancel notifications based on saved statuses or defaults
  for (var entry in defaultTimeSlots.entries) {
    final String activity = entry.key;
    final TimeOfDay time = timeSlots[activity] ?? entry.value;
    final bool isEnabled = enabledStatuses[activity] ?? true;

    final int notificationId = _getNotificationId(activity);

    if (isEnabled) {
      await notificationService.scheduleNotification(
        uniqueId: notificationId,
        activity: activity,
        hour: time.hour,
        minute: time.minute,
      );
    } else {
      await notificationService.cancelNotification(notificationId);
    }

    // Save default settings if not already saved
    if (!timeSlots.containsKey(activity)) {
      await timeStorage.saveTimeSlot(activity, time);
      await timeStorage.saveEnabledStatus(activity, isEnabled);
    }
  }
}

int _getNotificationId(String title) {
  switch (title) {
    case NotificationType.morningKickstart:
      return 100;
    case NotificationType.eveningWindDown:
      return 200;
    case NotificationType.focusReminder:
      return 300;
    case NotificationType.journalingCue:
      return 400;
    default:
      return 0; // Default ID for unknown titles
  }
}
