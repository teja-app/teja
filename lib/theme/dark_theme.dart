import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final textTheme = ThemeData.light().textTheme;
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: Colors.black,
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.grey.shade900, // This will be the background color for the time picker dialog.
    dialHandColor: Colors.teal, // The color for the clock hand.
    dialBackgroundColor: Colors.black, // The background color for the clock dial.
    dialTextColor: Colors.white, // The color for the text on the clock dial.
    dayPeriodTextColor: Colors.white, // The color for the text "AM" and "PM".

    hourMinuteTextColor: Colors.teal.shade200, // The color for the text of the selected hour and minute.
    dayPeriodColor: Colors.grey.shade800, // The background color for the "AM" and "PM" toggle.
    confirmButtonStyle: ButtonStyle(
      // Define background color for the button
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      // Define text style for the button
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.black, // Text color
          fontWeight: FontWeight.normal,
        ),
      ),
      // Define shape for the button
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    cancelButtonStyle: ButtonStyle(
      // Define background color for the button
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      // Define text style for the button
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white70, // Text color
          fontWeight: FontWeight.normal,
        ),
      ),
      // Define shape for the button
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    hourMinuteShape: RoundedRectangleBorder(
      // The shape for the hour and minute boxes.
      borderRadius: BorderRadius.circular(10),
    ),
    hourMinuteColor: Colors.teal.shade700,
    dayPeriodShape: RoundedRectangleBorder(
      // The shape for the "AM" and "PM" toggle boxes.
      borderRadius: BorderRadius.circular(10),
    ),
    entryModeIconColor: Colors.teal,
  ),
  textTheme: GoogleFonts.notoSansTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ).copyWith(
    titleMedium: GoogleFonts.outfit(
      textStyle: const TextTheme().titleMedium,
    ),
    titleLarge: GoogleFonts.outfit(
      textStyle: const TextTheme().titleLarge,
    ),
    titleSmall: GoogleFonts.outfit(
      textStyle: const TextTheme().titleSmall,
    ),
  ),
  cardTheme: CardTheme(color: Colors.grey.shade800),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.grey.shade800, // Dark theme popup menu color
  ),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    // seedColor: Colors.white,
    seedColor: Colors.white, // Adjust seed color for dark theme
    primary: Colors.black,
    secondary: Colors.grey,
    surface: Colors.white,
    background: Colors.grey.shade900,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey.shade900, // Set the color you want for the bottom sheet in dark mode
    modalBackgroundColor: Colors.grey.shade900, // This is for modal bottom sheets specifically
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    // backgroundColor: Colors.grey.shade900,
    color: Colors.grey.shade900,
  ),
  useMaterial3: true,
);
