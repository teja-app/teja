import 'package:flutter/material.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/shared/helpers/color.dart';

class FeelingButton extends StatelessWidget {
  final MasterFeelingEntity feeling;
  final bool isSelected;
  final Function(MasterFeelingEntity) onSelect;

  const FeelingButton({
    Key? key,
    required this.feeling,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  Color getFeelingColor(int pleasantness, int energy) {
    // Define colors for different levels of pleasantness
    Map<int, Color> baseColorMap = {
      1: const Color.fromARGB(255, 198, 174, 232), // Mood 1
      2: const Color.fromARGB(255, 178, 197, 247), // Mood 2
      3: const Color.fromARGB(255, 173, 218, 248), // Mood 3
      4: const Color.fromARGB(255, 180, 231, 228), // Mood 4
      5: const Color.fromARGB(255, 174, 222, 189), // Mood 5
    };

    // Calculate pleasantness level from -5 to 5 to a scale of 1 to 5
    int moodLevel = _mapPleasantnessToMood(pleasantness);

    Color baseColor = baseColorMap[moodLevel] ?? Colors.grey;

    // Use the absolute value of energy to adjust the darkness of the base color
    // The higher the energy, the darker the color
    double adjustmentFactor = (energy.abs() / 5); // Normalize energy to a value between 0 and 1
    // Darken the color
    return darken(baseColor, adjustmentFactor * 0.5);
  }

  int _mapPleasantnessToMood(int pleasantness) {
    if (pleasantness == -4 || pleasantness == -5) {
      return 1; // Mood 1
    } else if (pleasantness == -2 || pleasantness == -3) {
      return 2; // Mood 2
    } else if (pleasantness == -1 || pleasantness == 1) {
      return 3; // Mood 3
    } else if (pleasantness == 2 || pleasantness == 3) {
      return 4; // Mood 4
    } else if (pleasantness == 4 || pleasantness == 5) {
      return 5; // Mood 5
    } else {
      return 3; // Default to Mood 3 for any unexpected values
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSelected ? getFeelingColor(feeling.pleasantness, feeling.energy) : Colors.transparent;
    Color borderColor = getFeelingColor(feeling.pleasantness, feeling.energy);
    Color textColor = isSelected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => onSelect(feeling),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        height: 50,
        child: Center(
          child: Text(
            feeling.name,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
