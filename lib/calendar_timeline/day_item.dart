import 'package:flutter/material.dart';

/// Creates a Widget representing the day.
class DayItem extends StatelessWidget {
  const DayItem({
    Key? key,
    required this.dayNumber,
    required this.shortName,
    required this.onTap,
    this.isSelected = false,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor,
    this.shrink = false,
    this.isToday = false,
  }) : super(key: key);
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeDayBackgroundColor;
  final bool available;
  final Color? dotsColor;
  final Color? dayNameColor;
  final bool isToday; // Add this line
  final bool shrink;

  GestureDetector _buildDay(BuildContext context) {
    // Determine the base color based on availability
    final colorScheme = Theme.of(context).colorScheme;
    Color baseColor;

    if (available) {
      if (dayColor != null) {
        baseColor = dayColor!;
      } else {
        baseColor = colorScheme.secondary;
      }
    } else {
      if (dayColor != null) {
        baseColor = dayColor!.withOpacity(0.3);
      } else {
        baseColor = colorScheme.secondary.withOpacity(0.3);
      }
    }

    // Color baseColor = available
    //     ? dayColor ?? colorScheme.secondary
    //     : dayColor?.withOpacity(0.5) ??
    //         Theme.of(context).colorScheme.secondary.withOpacity(0.5);

    // Override base color if it's today
    Color finalColor = isToday ? colorScheme.primary : baseColor;

    final textStyle = TextStyle(
      color: finalColor,
      fontSize: shrink ? 14 : 32,
      fontWeight: FontWeight.normal,
    );
    final selectedStyle = TextStyle(
      color: activeDayColor ?? colorScheme.secondary,
      fontSize: shrink ? 14 : 32,
      fontWeight: FontWeight.bold,
    );

    return GestureDetector(
      onTap: available ? onTap as void Function()? : null,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: activeDayBackgroundColor ?? colorScheme.secondary,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.secondary, // Change this color as needed
                    width: 2.0, // You can adjust the width as required
                  ),
                ),
              )
            : const BoxDecoration(color: Colors.transparent),
        height: 70,
        width: 60,
        child: Column(
          children: <Widget>[
            Text(
              dayNumber.toString(),
              style: isSelected ? selectedStyle : textStyle,
            ),
            Text(
              shortName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? activeDayColor : finalColor,
                fontSize: shrink ? 9 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDay(context);
  }
}
