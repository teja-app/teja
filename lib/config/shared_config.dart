import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:teja/infrastructure/database/hive_collections/featured_journal_template.dart';
import 'package:teja/infrastructure/database/hive_collections/journal_category.dart';
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

final notificationService = NotificationService();

Future<Store<AppState>> configureCommonDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Isar isarInstance = await openIsar();
  logger.i("Database Instance is ready");

  await notificationService.initialize();
  logger.i("Notification Service Connected");

  if (Platform.isIOS) {
    await notificationService.requestIOSPermissions();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(FeaturedJournalTemplateAdapter());
  Hive.registerAdapter(JournalCategoryAdapter());
  await Hive.openBox(FeaturedJournalTemplate.boxKey);
  await Hive.openBox(JournalCategory.boxKey);

  final store = await createStore(isarInstance);
  logger.i("Connected to local data store");

  await notificationService.cancelAllNotifications();
  handleNotificationInitialize(notificationService);

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

  debugPrint("Executing background task");

  // Retrieve saved times and statuses
  final Map<String, TimeOfDay> timeSlots = await timeStorage.getTimeSlots();
  final Map<String, bool> enabledStatuses =
      await timeStorage.getEnabledStatuses();

  // Schedule or cancel notifications based on saved statuses
  for (var entry in timeSlots.entries) {
    final String activity = entry.key;
    final TimeOfDay time = entry.value;
    final bool isEnabled = enabledStatuses[activity] ?? false;

    final int notificationId = _getNotificationId(activity);

    if (isEnabled) {
      await notificationService.scheduleNotification(
        uniqueId: notificationId,
        title: activity,
        body: 'Reminder: $activity',
        hour: time.hour,
        minute: time.minute,
      );
    } else {
      await notificationService.cancelNotification(notificationId);
    }
  }
}

int _getNotificationId(String title) {
  switch (title) {
    case 'Morning Kickstart':
      return 100;
    case 'Evening Wind-down':
      return 200;
    case 'Focus Reminder':
      return 300;
    case 'Journaling Cue':
      return 400;
    default:
      return 0; // Default ID for unknown titles
  }
}
