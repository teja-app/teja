import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:swayam/app.dart';
import 'shared/helpers/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env.dev');
  final String? sentryDsnUrl = dotenv.env['SENTRY_DSN_URL'];
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsnUrl;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
      options.attachViewHierarchy = true;
    },
    appRunner: () {
      logger.i('SentryFlutter initialized successfully.');
      runApp(const App());
    },
  );
}
