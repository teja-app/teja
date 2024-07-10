import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teja/infrastructure/analytics/set_context.dart';
import 'package:teja/infrastructure/database/hive_collections/featured_journal_template.dart';
import 'package:teja/infrastructure/database/hive_collections/journal_category.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_template.dart';
import 'package:teja/infrastructure/database/isar_collections/master_factor.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';
import 'package:teja/infrastructure/database/isar_collections/quote.dart';
import 'package:teja/infrastructure/database/isar_collections/vision.dart';
import 'package:teja/infrastructure/utils/notification_service.dart';

import 'shared/helpers/logger.dart';

import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/store.dart'; // Make sure to import this

import 'package:teja/app.dart';

final notificationService = NotificationService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPosthogContext();
  await dotenv.load(fileName: '.env.dev');
  final String? sentryDsnUrl = dotenv.env['SENTRY_DSN_URL'];
  // Initialize Isar
  print("Loaded the ENV files");
  final Isar isarInstance = await openIsar();
  print("Database Instance is ready");

  // Initialize NotificationService
  await notificationService.initialize(); // Initialize notifications
  print("Notification Service Connected");

  if (Platform.isIOS) {
    // Request notification permissions on iOS
    await notificationService.requestIOSPermissions();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(FeaturedJournalTemplateAdapter());
  Hive.registerAdapter(JournalCategoryAdapter());
  await Hive.openBox(FeaturedJournalTemplate.boxKey);
  await Hive.openBox(JournalCategory.boxKey);

  // Initialize the store here
  final store = await createStore(isarInstance);
  print("Connected to local data store");

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsnUrl;
    },
    // Init your App.
    appRunner: () => runApp(MyApp(
      store: store,
    )),
  );
  print("SentryFlutter Initialized");
}

Future<Isar> openIsar() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  // Set up Isar and return the instance
  final isar = await Isar.open(
    [
      MoodLogSchema,
      MasterFeelingSchema,
      MasterFactorSchema,
      QuoteSchema,
      VisionSchema,
      JournalTemplateSchema,
      JournalEntrySchema,
    ],
    directory: path,
  );
  return isar;
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    print("Main App Build Opened");
    return StoreProvider(
      store: store,
      child: MaterialApp(
        navigatorObservers: [
          PosthogObserver(),
        ],
        debugShowCheckedModeBanner: false,
        home: const App(),
      ),
    );
  }
}
