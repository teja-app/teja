import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AppConfig {
  final String apiBaseUrl;
  final String sentryDsnUrl;
  final String environment;

  AppConfig({
    required this.apiBaseUrl,
    required this.sentryDsnUrl,
    required this.environment,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception("AppConfig must be initialized before accessing instance.");
    }
    return _instance!;
  }

  static Future<void> initialize(String env) async {
    final contents = await rootBundle.loadString('assets/config/$env.json');
    final json = jsonDecode(contents);
    _instance = AppConfig(
      apiBaseUrl: json['API_BASE_URL'],
      sentryDsnUrl: json['SENTRY_DSN_URL'],
      environment: json['ENVIRONMENT'],
    );
  }
}
