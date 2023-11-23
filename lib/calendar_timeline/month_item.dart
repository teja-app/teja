import 'package:flutter/material.dart';

/// Creates a Widget to represent the months.
class MonthItem extends StatelessWidget {
  const MonthItem({
    Key? key,
    required this.name,
    required this.onTap,
    this.isSelected = false,
    this.color,
    this.activeColor,
    this.shrink = false,
  }) : super(key: key);
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color? color;
  final Color? activeColor;
  final bool shrink;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color baseColor;

    if (isSelected) {
      if (activeColor != null) {
        baseColor = activeColor!;
      } else {
        baseColor = colorScheme.primary;
      }
    } else {
      if (color != null) {
        baseColor = color!;
      } else {
        baseColor = colorScheme.onBackground;
      }
    }

    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Text(
        name.toUpperCase(),
        style: TextStyle(
          color: baseColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
