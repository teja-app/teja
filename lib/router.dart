import 'package:go_router/go_router.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/onboarding_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OnboardingPage(),
    ),
  ],
);
