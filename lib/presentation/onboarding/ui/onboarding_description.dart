import 'package:flutter/material.dart';

class OnboardingDescription extends StatelessWidget {
  const OnboardingDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        "Discover your journey towards a balanced life with personalized journaling, mood tracking, and self-improvement strategies.",
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
