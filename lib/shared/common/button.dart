import 'package:flutter/material.dart';

enum ButtonType { defaultButton, primary, secondary, disabled }

class Button extends StatelessWidget {
  final String text;
  final String? secondaryText;
  final void Function()? onPressed;
  final double? width;
  final IconData? icon;
  final double margin;
  final double spacing;
  final double runSpacing;
  final ButtonType buttonType;

  const Button({
    super.key,
    required this.text,
    this.secondaryText,
    this.onPressed,
    this.icon,
    this.width = 40,
    this.margin = 8.0,
    this.spacing = 8.0,
    this.runSpacing = 4.0,
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
      case ButtonType.disabled:
        textColor = Colors.grey;
        backgroundColor = Colors.transparent;
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
      margin: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          maximumSize: const Size(double.infinity, 42),
          minimumSize: Size(width ?? 40, 42),
          side: BorderSide(color: borderColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: spacing, // space between parts horizontally
            runSpacing: runSpacing, // space between parts vertically when wrapping
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: textColor,
                  size: 16,
                ),
              Text(
                text,
                style: TextStyle(color: textColor),
              ),
              if (secondaryText != null)
                Text(
                  secondaryText!,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
