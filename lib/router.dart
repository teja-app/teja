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

GoRouter createRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation, // Use the initialLocation parameter here
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
