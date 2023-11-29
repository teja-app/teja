import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final textTheme = ThemeData.light().textTheme;
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: Colors.black,
  textTheme: GoogleFonts.ubuntuTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
  cardTheme: CardTheme(color: Colors.grey.shade800),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.grey.shade800, // Dark theme popup menu color
  ),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    // seedColor: Colors.white,
    seedColor: Colors.white, // Adjust seed color for dark theme
    primary: Colors.lightBlueAccent,
    secondary: Colors.grey,
    surface: Colors.white,
    background: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    // backgroundColor: Colors.grey.shade900,
    color: Colors.grey.shade900,
  ),
  useMaterial3: true,
);
