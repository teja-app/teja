import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingHeaderImage extends StatelessWidget {
  final Brightness themeBrightness;

  const OnboardingHeaderImage({Key? key, required this.themeBrightness}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      themeBrightness == Brightness.dark ? "assets/logo/White.svg" : "assets/logo/Color.svg",
      width: 80, // Adjust the size as needed
      height: 80,
    );
  }
}
