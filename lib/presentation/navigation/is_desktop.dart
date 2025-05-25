import 'package:flutter/material.dart';

bool isDesktop(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > 600; // You can adjust this threshold as needed
}
