// lib/infrastructure/analytics/analytics_service.dart

import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:teja/config/app_config.dart';
import 'package:teja/shared/helpers/logger.dart';

abstract class AnalyticsProvider {
  Future<void> setup();
  void identify(String userId, Map<String, Object> traits);
  void track(String eventName, Map<String, Object> properties);
  void screen(String screenName, Map<String, Object> properties);
}

class PosthogAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> setup() async {}

  @override
  void identify(String userId, Map<String, Object> traits) {
    Posthog().identify(userId: userId, userProperties: traits);
  }

  @override
  void track(String eventName, Map<String, Object> properties) {
    Posthog().capture(eventName: eventName, properties: properties);
  }

  @override
  void screen(String screenName, Map<String, Object> properties) {
    Posthog().screen(screenName: screenName, properties: properties);
  }
}

class DevAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> setup() async {
    // No setup needed for dev logging
  }

  @override
  void identify(String userId, Map<String, Object> traits) {
    logger.i('DEV ANALYTICS - Identify: $userId, Traits: $traits');
  }

  @override
  void track(String eventName, Map<String, Object> properties) {
    logger.i('DEV ANALYTICS - Track: $eventName, Properties: $properties');
  }

  @override
  void screen(String screenName, Map<String, Object> properties) {
    logger.i('DEV ANALYTICS - Screen: $screenName, Properties: $properties');
  }
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  late AnalyticsProvider _provider;
  bool _isInitialized = false;

  Future<void> setup() async {
    if (!_isInitialized) {
      _provider = AppConfig.instance.environment == 'production' ? PosthogAnalyticsProvider() : DevAnalyticsProvider();
      await _provider.setup();
      _isInitialized = true;
    }
  }

  void identify(String userId, Map<String, Object> traits) {
    if (!_isInitialized) {
      print('AnalyticsService not initialized. Call setup() first.');
      return;
    }
    _provider.identify(userId, traits);
  }

  void track(String eventName, Map<String, Object> properties) {
    if (!_isInitialized) {
      print('AnalyticsService not initialized. Call setup() first.');
      return;
    }
    _provider.track(eventName, properties);
  }

  void screen(String screenName, Map<String, Object> properties) {
    if (!_isInitialized) {
      print('AnalyticsService not initialized. Call setup() first.');
      return;
    }
    _provider.screen(screenName, properties);
  }
}
