import 'package:flutter/material.dart';
import 'package:teja/shared/common/button.dart';

class CustomCategoriesButton extends StatelessWidget {
  const CustomCategoriesButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Button(
          text: title,
        ),
      ],
    );
  }
}
