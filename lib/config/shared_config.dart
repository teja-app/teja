import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:teja/infrastructure/database/hive_collections/featured_journal_template.dart';
import 'package:teja/infrastructure/database/hive_collections/journal_category.dart';
import 'package:teja/infrastructure/database/hive_collections/notification_time_slot.dart';
import 'package:teja/infrastructure/database/hive_collections/user_preference.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_template.dart';
import 'package:teja/infrastructure/database/isar_collections/master_factor.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';
import 'package:teja/infrastructure/database/isar_collections/quote.dart';
import 'package:teja/infrastructure/database/isar_collections/task.dart';
import 'package:teja/infrastructure/database/isar_collections/vision.dart';
import 'package:teja/infrastructure/utils/notification_service.dart';
import 'package:teja/infrastructure/utils/time_storage_helper.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/store.dart';
import 'package:teja/infrastructure/constants/notification_types.dart';

final notificationService = NotificationService();

Future<Store<AppState>> configureCommonDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Isar isarInstance = await openIsar();
  logger.i("Database Instance is ready");

  await notificationService.initialize();
  logger.i("Notification Service Connected");

  if (Platform.isIOS) {
    logger.i("Notification Service Connected on iOS");
    await notificationService.requestIOSPermissions();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(FeaturedJournalTemplateAdapter());
  Hive.registerAdapter(JournalCategoryAdapter());
  Hive.registerAdapter(TimeSlotAdapter());
  Hive.registerAdapter(UserPreferenceAdapter());
  await Hive.openBox(FeaturedJournalTemplate.boxKey);
  await Hive.openBox(JournalCategory.boxKey);
  await Hive.openBox(TimeSlot.boxKey);
  await Hive.openBox(UserPreference.boxKey);

  final store = await createStore(isarInstance);
  logger.i("Connected to local data store");

  await notificationService.cancelAllNotifications();
  await handleNotificationInitialize(notificationService);

  return store;
}

Future<Isar> openIsar() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return await Isar.open(
    [
      MoodLogSchema,
      MasterFeelingSchema,
      MasterFactorSchema,
      QuoteSchema,
      VisionSchema,
      JournalTemplateSchema,
      JournalEntrySchema,
      TaskSchema
    ],
    directory: path,
  );
}

Future<void> handleNotificationInitialize(
    NotificationService notificationService) async {
  final TimeStorage timeStorage = TimeStorage();

  // Retrieve saved times and statuses
  final Map<String, TimeOfDay> timeSlots = await timeStorage.getAllTimeSlots();
  final Map<String, bool> enabledStatuses =
      await timeStorage.getEnabledStatuses();

  // Default settings
  final Map<String, TimeOfDay> defaultTimeSlots = {
    NotificationType.MORNING_KICKSTART: const TimeOfDay(hour: 9, minute: 0),
    NotificationType.EVENING_WIND_DOWN: const TimeOfDay(hour: 21, minute: 0),
    NotificationType.FOCUS_REMINDER: const TimeOfDay(hour: 14, minute: 30),
    NotificationType.JOURNALING_CUE: const TimeOfDay(hour: 12, minute: 0),
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
    case NotificationType.MORNING_KICKSTART:
      return 100;
    case NotificationType.EVENING_WIND_DOWN:
      return 200;
    case NotificationType.FOCUS_REMINDER:
      return 300;
    case NotificationType.JOURNALING_CUE:
      return 400;
    default:
      return 0; // Default ID for unknown titles
  }
}
