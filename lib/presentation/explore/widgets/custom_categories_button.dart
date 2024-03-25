import 'package:flutter/material.dart';
import 'package:teja/shared/common/button.dart';

class CustomCategoriesButton extends StatelessWidget {
  const CustomCategoriesButton({
    Key? key,
    required this.title,
    this.onTap, // Add an onTap callback
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap; // Define the callback type

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap, // Use the onTap callback
          child: Button(
            text: title,
          ),
        ),
      ],
    );
  }
}
