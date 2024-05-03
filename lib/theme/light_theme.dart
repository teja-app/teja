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
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.white, // Background color for the time picker dialog
    dialHandColor: Colors.black, // Color for the clock hand
    dialBackgroundColor: Colors.white, // Background color for the clock dial
    dialTextColor: Colors.black, // Color for the text on the clock dial
    dayPeriodTextColor: Colors.black, // Color for the text "AM" and "PM"
    hourMinuteTextColor: Colors.black, // Color for the text of the selected hour and minute
    dayPeriodColor: Colors.white, // Background color for the "AM" and "PM" toggle
    confirmButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Background color for the confirm button
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color for the confirm button
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white, // Text color
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Background color for the cancel button
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color for the cancel button
      // Define text style for the button
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white, // Text color
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
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.black), // Border color for the hour and minute boxes
    ),
    dayPeriodShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.black), // Border color for the "AM" and "PM" toggle boxes
    ),
    entryModeIconColor: Colors.black, // Color for the entry mode icon
    helpTextStyle: const TextStyle(
      color: Colors.black, // Color for the help text
      fontSize: 16,
    ),
  ),
  cardTheme: const CardTheme(color: Colors.white),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white, // Set your desired color here
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    primary: Colors.black,
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
