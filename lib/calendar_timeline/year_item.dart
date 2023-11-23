import 'package:flutter/material.dart';

/// Creates a Widget to represent the years.
class YearItem extends StatelessWidget {
  const YearItem({
    Key? key,
    required this.name,
    required this.onTap,
    this.isSelected = false,
    this.small = true,
    this.color,
  }) : super(key: key);
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color? color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final baseColor = color ?? Colors.black87;
    TextStyle textStyle;

    if (small) {
      textStyle = textTheme.bodySmall
              ?.copyWith(color: baseColor, fontWeight: FontWeight.bold) ??
          const TextStyle();
    } else {
      textStyle = textTheme.titleLarge
              ?.copyWith(color: baseColor, fontWeight: FontWeight.bold) ??
          const TextStyle();
    }

    BoxDecoration? decoration = isSelected || small
        ? BoxDecoration(
            border: Border.all(color: baseColor),
            borderRadius: BorderRadius.circular(4),
          )
        : null;

    return GestureDetector(
      onTap: small ? null : onTap as void Function()?,
      child: Container(
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Text(
            name.toUpperCase(),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
