import 'package:flutter/material.dart';
import 'package:teja/domain/entities/master_feeling.dart';

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

  @override
  Widget build(BuildContext context) {
    Color getFeelingColor(int pleasantness) {
      // Define colors for different levels of pleasantness
      Map<int, Color> colorMap = {
        -5: Colors.red[900]!, // Extremely unpleasant
        -4: Colors.red[700]!,
        -3: Colors.red[500]!,
        -2: Colors.red[300]!,
        -1: Colors.red[100]!,
        0: Colors.grey, // Neutral
        1: Colors.blue[100]!,
        2: Colors.blue[300]!,
        3: Colors.blue[500]!,
        4: Colors.blue[700]!,
        5: Colors.blue[900]!, // Extremely pleasant
      };

      return colorMap[pleasantness] ?? Colors.grey; // Default to grey if the value is out of range
    }

    return GestureDetector(
      onTap: () => onSelect(feeling),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? getFeelingColor(feeling.pleasantness) : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            feeling.name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
