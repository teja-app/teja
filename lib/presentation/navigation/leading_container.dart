import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget leadingNavBar(BuildContext context) {
  final Brightness themeBrightness = Theme.of(context).brightness;

  return Container(
    padding: const EdgeInsets.only(top: 10, left: 8),
    width: 56, // AppBar's leading space is typically around 56x56
    height: 56,
    child: Center(
      // Center the SvgPicture
      child: SvgPicture.asset(
        themeBrightness == Brightness.dark
            ? "assets/logo/White.svg"
            : "assets/logo/Color.svg",
        width: 30,
        height: 30,
      ),
    ),
  );
}
