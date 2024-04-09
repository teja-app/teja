import 'package:flutter/material.dart';
import 'package:teja/shared/common/button.dart'; // Assuming this is your custom button widget

typedef OnPressedCallback = Function();

class BeginButton extends StatelessWidget {
  final OnPressedCallback onPressedCallback;

  const BeginButton({Key? key, required this.onPressedCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button(
      key: const Key("homePage"),
      text: "Let's Begin",
      width: 300,
      onPressed: () => onPressedCallback(),
    );
  }
}
