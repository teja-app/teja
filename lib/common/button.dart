import 'package:flutter/material.dart';

enum ButtonType { defaultButton, primary, secondary }

class Button extends StatelessWidget {
  final String text;
  final String? secondaryText;
  final void Function()? onPressed;
  final double? width;
  final ButtonType buttonType;

  const Button({
    super.key,
    required this.text,
    this.secondaryText,
    this.onPressed,
    this.width = 40,
    this.buttonType = ButtonType.defaultButton,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (buttonType) {
      case ButtonType.primary:
        textColor = Colors.white;
        backgroundColor = Colors.black;
        borderColor = Colors.transparent;
        break;
      case ButtonType.secondary:
        textColor = Colors.black;
        backgroundColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case ButtonType.defaultButton:
      default:
        textColor = Colors.black;
        backgroundColor = Colors.white;
        borderColor = Colors.black;
        break;
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(color: textColor),
              ),
              if (secondaryText != null)
                Text(
                  secondaryText!,
                  style: TextStyle(
                      color: textColor.withOpacity(0.7), fontSize: 12),
                ),
            ],
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          primary: textColor,
          maximumSize: Size(double.infinity, 42),
          minimumSize: Size(width ?? 40, 42),
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
