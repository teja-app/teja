import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:swayam/features/home/presentation/home_page.dart';
import 'package:swayam/features/mood/persentation/pages/mood.dart';
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
}

class SettingPath {
  static const notification = "notification";
  static const perferences = "perferences";
  static const basic = "basic";
  static const security = "security";
  static const advanced = "advanced";
}

class RootPath {
  static const root = "root";
  static const signUp = "signUp";
  static const signIn = "signIn";
  static const home = "home";
  static const settings = "settings";
  static const mood = "mood";
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  // initialLocation: initialLocation, // Use the initialLocation parameter here
  debugLogDiagnostics: true,
  observers: [RouteLoggingObserver()],
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.root,
      path: '/',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.signUp,
      path: '/sign_up',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.signIn,
      path: '/sign_in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.home,
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.mood,
      path: '/mood',
      builder: (context, state) => const MoodPage(),
    ),
    GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: RootPath.settings,
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            name: SettingPath.notification,
            path: 'notification',
            builder: (context, state) => NotificationSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.perferences,
            path: 'perferences',
            builder: (context, state) => PreferencesSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.basic,
            path: 'basic',
            builder: (context, state) => BasicSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.security,
            path: 'security',
            builder: (context, state) => SecuritySettingsPage(),
          ),
          GoRoute(
            name: SettingPath.advanced,
            path: 'advanced',
            builder: (context, state) => AdvancedSettingsPage(),
          ),
        ])
  ],
);
