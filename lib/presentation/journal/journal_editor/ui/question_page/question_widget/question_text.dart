import 'package:flutter/material.dart';

Widget buildQuestionText(String questionText, TextTheme textTheme) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
      questionText,
      style: textTheme.bodyMedium,
    ),
  );
}
