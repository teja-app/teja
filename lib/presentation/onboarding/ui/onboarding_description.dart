import 'package:flutter/material.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';

class OnboardingDescription extends StatelessWidget {
  const OnboardingDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          width: isDesktop(context) ? 500 : double.infinity,
          child: Text(
            "Discover your journey towards a balanced life with personalized journaling, mood tracking, and self-improvement strategies.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ));
  }
}
