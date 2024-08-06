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
    titleSmall: GoogleFonts.wixMadeforText(
      textStyle: const TextTheme().bodySmall,
      color: Colors.grey.shade900,
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.white,
    dialHandColor: Colors.green[600],
    dialBackgroundColor: Colors.green[50],
    dialTextColor: Colors.black,
    dayPeriodTextColor: Colors.black,
    hourMinuteTextColor: Colors.black,
    dayPeriodColor: Colors.white,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.green[600]!),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]!),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
    hourMinuteShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.green[600]!),
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.green[600]!),
    ),
    entryModeIconColor: Colors.green[600],
    helpTextStyle: TextStyle(
      color: Colors.grey[600],
      fontSize: 16,
    ),
  ),
  cardTheme: CardTheme(color: Colors.grey.shade50),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.green[600]!,
    secondary: Colors.grey[400]!,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Colors.green[400],
  ),
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    foregroundColor: Colors.black,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green[600],
    foregroundColor: Colors.white,
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.green[600]!;
          }
          return Colors.white;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.black;
        },
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  ),
  useMaterial3: true,
);
