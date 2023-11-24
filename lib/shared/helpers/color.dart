import 'package:flutter/material.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1, 'amount must be between 0 and 1');

  final hsl = HSLColor.fromColor(color);
  final hslDarkened =
      hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDarkened.toColor();
}
