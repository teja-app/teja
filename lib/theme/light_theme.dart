import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  cardColor: Colors.white,
  textTheme: GoogleFonts.notoSansTextTheme().copyWith(
    bodyMedium: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodyMedium,
    ),
    bodyLarge: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodyLarge,
    ),
    bodySmall: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodySmall,
    ),
  ),
  cardTheme: const CardTheme(color: Colors.white),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white, // Set your desired color here
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    primary: Colors.lightBlueAccent,
    secondary: Colors.black,
    surface: Colors.black,
    background: Colors.grey.shade100,
  ),
  scaffoldBackgroundColor: Colors.grey.shade100,
  appBarTheme: AppBarTheme(
    // backgroundColor: Colors.grey.shade100,
    color: Colors.grey.shade100,
  ),
  useMaterial3: true,
);
