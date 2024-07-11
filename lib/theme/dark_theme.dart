import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: Colors.black,
  textTheme: GoogleFonts.notoSansTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ).copyWith(
    bodyMedium: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodyMedium,
    ),
    bodyLarge: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodyLarge,
    ),
    bodySmall: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodySmall,
    ),
    titleSmall: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodySmall,
      color: Colors.grey.shade300,
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.black,
    dialHandColor: Colors.white,
    dialBackgroundColor: Colors.black,
    dialTextColor: Colors.white,
    dayPeriodTextColor: Colors.white,
    hourMinuteTextColor: Colors.white,
    dayPeriodColor: Colors.black,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.black,
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
      side: const BorderSide(color: Colors.white),
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.white),
    ),
    entryModeIconColor: Colors.white,
    helpTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade900,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.black,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    brightness: Brightness.dark,
    primary: Colors.white,
    secondary: Colors.grey.shade300,
    surface: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Colors.black,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return Colors.white;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black;
        },
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  ),
  useMaterial3: true,
);
