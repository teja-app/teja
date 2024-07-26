import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/shared_config.dart';
import 'package:teja/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  final store = await configureCommonDependencies('.env.dev');

  // Dev-specific configurations
  final String? sentryDsnUrl = dotenv.env['SENTRY_DSN_URL'];

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsnUrl;
      options.environment = 'development';
      // Add any other dev-specific Sentry options here
    },
    appRunner: () => runApp(App(store: store)),
  );

  logger.i("App initialized in development mode");
}
