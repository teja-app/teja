import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:swayam/presentation/home/pages/home_page.dart';
import 'package:swayam/presentation/mood/detail/page/mood_detail.dart';
import 'package:swayam/presentation/mood/editor/pages/mood_edit.dart';
import 'package:swayam/presentation/mood/list/pages/mood_list_page.dart';
import 'package:swayam/presentation/onboarding/pages/onboarding_page.dart';
import 'package:swayam/presentation/onboarding/pages/sign_in_page.dart';
import 'package:swayam/presentation/onboarding/pages/sign_up_page.dart';
import 'package:swayam/presentation/profile/page/ProfilePage.dart';
import 'package:swayam/presentation/settings/pages/advanced_settings_page.dart';
import 'package:swayam/presentation/settings/pages/basic_settings_page.dart';
import 'package:swayam/presentation/settings/pages/notification_settings_page.dart';
import 'package:swayam/presentation/settings/pages/perference_settings_page.dart';
import 'package:swayam/presentation/settings/pages/security_settings_page.dart';
import 'package:swayam/presentation/settings/pages/settings_page.dart';
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
  static const profile = "profile";
  static const settings = "settings";
  static const moodEdit = "mood_edit";
  static const moodList = "mood_list";
  static const moodDetail = "mood_detail";
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
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.profile,
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.moodEdit,
      path: '/mood_edit',
      builder: (context, state) => const MoodEditPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.moodList,
      path: '/mood_list',
      builder: (context, state) => MoodListPage(),
    ),
    GoRoute(
      // Add this block for mood detail page
      parentNavigatorKey: _rootNavigatorKey,
      name: RootPath.moodDetail,
      path: '/mood_detail',
      builder: (context, state) {
        final String? moodIdStr = state.uri.queryParameters['id'];
        return MoodDetailPage(moodId: moodIdStr!);
      },
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
            builder: (context, state) => const NotificationSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.perferences,
            path: 'perferences',
            builder: (context, state) => const PreferencesSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.basic,
            path: 'basic',
            builder: (context, state) => const BasicSettingsPage(),
          ),
          GoRoute(
            name: SettingPath.security,
            path: 'security',
            builder: (context, state) => const SecuritySettingsPage(),
          ),
          GoRoute(
            name: SettingPath.advanced,
            path: 'advanced',
            builder: (context, state) => const AdvancedSettingsPage(),
          ),
        ])
  ],
);
