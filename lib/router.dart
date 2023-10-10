import 'package:go_router/go_router.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/onboarding_page.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/sign_in_page.dart';
import 'package:swayam/features/onboarding/presentation/ui/pages/sign_up_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (
        context,
        state,
      ) =>
          OnboardingPage(),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => SignInPage(),
    ),
  ],
);
