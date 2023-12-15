import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness themeBrightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image or SVG just above the title
                  SvgPicture.asset(
                    themeBrightness == Brightness.dark ? "assets/logo/White.svg" : "assets/logo/Color.svg",
                    width: 80, // Adjust the size as needed
                    height: 80,
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Personal way to bloom",
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Discover your journey towards a balanced life with personalized journaling, mood tracking, and self-improvement strategies.",
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Button(
                    key: const Key("homePage"),
                    text: "Let's Begin",
                    width: 300,
                    onPressed: () => GoRouter.of(context).replaceNamed(RootPath.home),
                    buttonType: ButtonType.primary,
                  ),
                  const SizedBox(height: 20), // Add spacing at the bottom for better layout
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
