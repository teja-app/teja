import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:teja/config/shared_config.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/app.dart';
import 'package:teja/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize('dev');
  final store = await configureCommonDependencies();

  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.instance.sentryDsnUrl;
      options.environment = AppConfig.instance.environment;
    },
    appRunner: () => runApp(App(store: store)),
  );

  logger.i("App initialized in ${AppConfig.instance.environment} mode");
}
