import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
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
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.white,
    dialHandColor: Colors.black,
    dialBackgroundColor: Colors.white,
    dialTextColor: Colors.black,
    dayPeriodTextColor: Colors.black,
    hourMinuteTextColor: Colors.black,
    dayPeriodColor: Colors.white,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    hourMinuteShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.black),
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.black),
    ),
    entryModeIconColor: Colors.black,
    helpTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
  cardTheme: CardTheme(color: Colors.grey.shade300),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    brightness: Brightness.light,
    primary: Colors.black,
    secondary: Colors.grey[900],
    surface: Colors.black,
    background: Colors.grey.shade100,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey.shade100,
  appBarTheme: AppBarTheme(
    color: Colors.grey.shade100,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  useMaterial3: true,
);
