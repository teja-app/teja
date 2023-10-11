import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryLogger extends Logger {
  final SentryClient _sentry = SentryClient(SentryOptions(dsn: 'YOUR_DSN'));

  @override
  void log(
    Level level,
    message, {
    error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    // Log locally
    super.log(
      level,
      message,
      error: error,
      stackTrace: stackTrace,
      time: time,
    );

    if (level == Level.info || level == Level.trace) {
      Sentry.addBreadcrumb(Breadcrumb(message: message.toString()));
    } else {
      _sentry.captureMessage(
        message.toString(),
        level: _convertLogLevelToSentryLevel(level),
      );
    }
  }

  SentryLevel _convertLogLevelToSentryLevel(Level level) {
    switch (level) {
      case Level.trace:
        return SentryLevel.debug;
      case Level.debug:
        return SentryLevel.debug;
      case Level.info:
        return SentryLevel.info;
      case Level.warning:
        return SentryLevel.warning;
      case Level.error:
        return SentryLevel.error;
      default:
        return SentryLevel.info;
    }
  }
}

final Logger logger = SentryLogger();
