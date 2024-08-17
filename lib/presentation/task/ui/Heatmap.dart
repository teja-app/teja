import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:teja/presentation/task/interface/task.dart';

class HeatMapComponent extends StatelessWidget {
  final String title;
  final Map<DateTime, int> dataset;
  final HabitDirection? habitDirection;

  const HeatMapComponent({
    Key? key,
    required this.title,
    required this.dataset,
    this.habitDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final defaultColor = brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200];

    Map<int, Color> colorsets;
    if (habitDirection == HabitDirection.negative) {
      colorsets = {
        1: Colors.red[100]!,
        3: Colors.red[300]!,
        5: Colors.red[500]!,
        7: Colors.red[700]!,
        9: Colors.red[900]!,
      };
    } else {
      colorsets = {
        1: Colors.blue[100]!,
        3: Colors.blue[300]!,
        5: Colors.blue[500]!,
        7: Colors.blue[700]!,
        9: Colors.blue[900]!,
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: HeatMapCalendar(
            initDate: DateTime.now(),
            datasets: dataset,
            colorMode: ColorMode.color,
            defaultColor: defaultColor,
            textColor: textColor,
            showColorTip: false,
            colorsets: colorsets,
            onClick: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected date: ${value.toString().split(' ')[0]}')),
              );
            },
            margin: const EdgeInsets.all(4),
          ),
        ),
      ],
    );
  }
}
