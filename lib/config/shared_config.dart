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
