import 'package:flutter/material.dart';

enum ButtonType { defaultButton, primary, secondary, disabled }

class Button extends StatelessWidget {
  final String text;
  final String? secondaryText;
  final VoidCallback? onPressed;
  final double? width;
  final IconData? icon;
  final double margin;
  final double spacing;
  final double runSpacing;
  final ButtonType buttonType;
  final double buttonRadius;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final double height;
  final TextStyle? textStyle;
  final TextStyle? secondaryTextStyle;

  const Button({
    Key? key,
    required this.text,
    this.secondaryText,
    this.onPressed,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.margin = 8.0,
    this.spacing = 8.0,
    this.runSpacing = 4.0,
    this.buttonType = ButtonType.defaultButton,
    this.buttonRadius = 8.0,
    this.elevation = 0,
    this.height = 42,
    this.textStyle,
    this.secondaryTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Color getTextColor() {
      switch (buttonType) {
        case ButtonType.primary:
          return textColor ?? theme.colorScheme.onPrimary;
        case ButtonType.secondary:
          return textColor ?? theme.colorScheme.onSecondary;
        case ButtonType.disabled:
          return Colors.grey;
        case ButtonType.defaultButton:
        default:
          return textColor ?? theme.colorScheme.onSurface;
      }
    }

    Color getBackgroundColor() {
      switch (buttonType) {
        case ButtonType.primary:
          return backgroundColor ?? theme.colorScheme.primary;
        case ButtonType.secondary:
          return backgroundColor ?? theme.colorScheme.secondary;
        case ButtonType.disabled:
          return Colors.grey.withOpacity(0.3);
        case ButtonType.defaultButton:
        default:
          return backgroundColor ?? theme.colorScheme.surface;
      }
    }

    Color getBorderColor() {
      switch (buttonType) {
        case ButtonType.primary:
        case ButtonType.secondary:
          return Colors.transparent;
        case ButtonType.disabled:
          return Colors.grey.withOpacity(0.5);
        case ButtonType.defaultButton:
        default:
          return borderColor ?? theme.colorScheme.outline;
      }
    }

    return Container(
      margin: EdgeInsets.all(margin),
      child: ElevatedButton(
        onPressed: buttonType == ButtonType.disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: getTextColor(),
          backgroundColor: getBackgroundColor(),
          elevation: elevation,
          minimumSize: Size(width ?? 40, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            side: BorderSide(color: getBorderColor()),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(icon, size: 18, color: getTextColor()),
              ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: textStyle?.copyWith(color: getTextColor()) ?? TextStyle(color: getTextColor()),
                  ),
                  if (secondaryText != null)
                    Text(
                      secondaryText!,
                      style: secondaryTextStyle?.copyWith(color: getTextColor().withOpacity(0.7)) ??
                          TextStyle(
                            color: getTextColor().withOpacity(0.7),
                            fontSize: 12,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
