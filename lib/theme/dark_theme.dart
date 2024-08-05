import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: const Color(0xFF2C2C2C), // Darker gray for cards
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
    backgroundColor: const Color(0xFF3A3A3A),
    dialHandColor: Colors.green[400],
    dialBackgroundColor: const Color(0xFF2C2C2C),
    dialTextColor: Colors.white,
    dayPeriodTextColor: Colors.white,
    hourMinuteTextColor: Colors.white,
    dayPeriodColor: const Color(0xFF3A3A3A),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.green[400]!),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[700]!),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    hourMinuteShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.green[400]!),
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.green[400]!),
    ),
    entryModeIconColor: Colors.green[400],
    helpTextStyle: TextStyle(
      color: Colors.grey[300],
      fontSize: 16,
    ),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF2C2C2C),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color(0xFF3A3A3A),
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.green[400]!,
    secondary: Colors.green[200]!,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    indicatorColor: Color.fromARGB(255, 48, 49, 48),
  ),
  scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Dark gray scaffold background
  appBarTheme: const AppBarTheme(
    color: Color(0xFF2C2C2C),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green[400],
    foregroundColor: Colors.black,
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.black;
          }
          return Colors.white;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.green[400]!;
          }
          return const Color(0xFF3A3A3A);
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
