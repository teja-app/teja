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
    backgroundColor: Colors
        .blueGrey, // This will be the background color for the time picker dialog.
    dialHandColor: Colors.black, // The color for the clock hand.
    dialBackgroundColor:
        Colors.black, // The background color for the clock dial.
    dialTextColor: Colors.white, // The color for the text on the clock dial.
    dayPeriodTextColor: Colors.white, // The color for the text "AM" and "PM".

    hourMinuteTextColor:
        Colors.white, // The color for the text of the selected hour and minute.
    dayPeriodColor:
        Colors.black, // The background color for the "AM" and "PM" toggle.
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
    hourMinuteColor:
        Colors.black, // The background color for the selected hour and minute.
    dayPeriodShape: RoundedRectangleBorder(
      // The shape for the "AM" and "PM" toggle boxes.
      borderRadius: BorderRadius.circular(10),
    ),
    entryModeIconColor: Colors.black, // The color for the entry mode icon.
    helpTextStyle: const TextStyle(
      color: Colors.white,
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
