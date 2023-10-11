import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:swayam/features/home/presentation/home_page.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/onboarding_page.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/sign_in_page.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/sign_up_page.dart';
import 'package:swayam/features/settings/presentation/ui/pages/advanced_settings_page.dart';
import 'package:swayam/features/settings/presentation/ui/pages/basic_settings_page.dart';
import 'package:swayam/features/settings/presentation/ui/pages/notification_settings_page.dart';
import 'package:swayam/features/settings/presentation/ui/pages/perference_settings_page.dart';
import 'package:swayam/features/settings/presentation/ui/pages/security_settings_page.dart';
import 'package:swayam/features/settings/presentation/ui/pages/settings_page.dart';
import 'package:swayam/shared/helpers/logger.dart';

class RouteLoggingObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Log when a new route is pushed onto the navigator stack
    logger.i('Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Log when a route is popped from the navigator stack
    logger.i('Popped route: ${route.settings.name}');
  }

  // You can override other methods like `didReplace`, `didRemove`, etc., as needed
}

GoRouter createRouter(String initialLocation) {
  logger.i('Creating router with initial location: $initialLocation');

  return GoRouter(
    initialLocation: initialLocation, // Use the initialLocation parameter here
    debugLogDiagnostics: true,
    observers: [RouteLoggingObserver()],
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: '/sign_in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
          routes: [
            GoRoute(
              path: 'notification',
              builder: (context, state) => NotificationSettingsPage(),
            ),
            GoRoute(
              path: 'perferences',
              builder: (context, state) => PreferencesSettingsPage(),
            ),
            GoRoute(
              path: 'basic',
              builder: (context, state) => BasicSettingsPage(),
            ),
            GoRoute(
              path: 'security',
              builder: (context, state) => SecuritySettingsPage(),
            ),
            GoRoute(
              path: 'advanced',
              builder: (context, state) => AdvancedSettingsPage(),
            ),
          ])
    ],
  );
}
