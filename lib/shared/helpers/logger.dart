import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryLogger extends Logger {
  @override
  void log(
    Level level,
    dynamic message, {
    dynamic error,
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
      Sentry.captureMessage(
        message.toString(),
        level: _convertLogLevelToSentryLevel(level),
      );
    }
  }

  SentryLevel _convertLogLevelToSentryLevel(Level level) {
    switch (level) {
      case Level.trace:
      case Level.debug:
        return SentryLevel.debug;
      case Level.info:
        return SentryLevel.info;
      case Level.warning:
        return SentryLevel.warning;
      case Level.error:
      case Level.fatal:
        return SentryLevel.error;
      default:
        return SentryLevel.info;
    }
  }
}

final Logger logger = SentryLogger();
