import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'shared/helpers/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swayam/domain/redux/store.dart'; // Make sure to import this
import 'package:swayam/app.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/state/app_state.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env.dev');
  final String? sentryDsnUrl = dotenv.env['SENTRY_DSN_URL'];

  // Initialize the store here
  final store = await createStore();

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsnUrl;
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
      options.attachViewHierarchy = true;
    },
    appRunner: () {
      logger.i('SentryFlutter initialized successfully.');
      runApp(MyApp(store: store));
    },
  );
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: const MaterialApp(
        home: App(),
      ),
    );
  }
}
