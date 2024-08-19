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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final defaultColor = brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200];

    Map<int, Color> colorsets;
    if (habitDirection == HabitDirection.negative) {
      colorsets = {
        1: colorScheme.error.withOpacity(0.2),
        3: colorScheme.error.withOpacity(0.4),
        5: colorScheme.error.withOpacity(0.6),
        7: colorScheme.error.withOpacity(0.8),
        9: colorScheme.error,
      };
    } else {
      colorsets = {
        1: colorScheme.primary.withOpacity(0.2),
        3: colorScheme.primary.withOpacity(0.4),
        5: colorScheme.primary.withOpacity(0.6),
        7: colorScheme.primary.withOpacity(0.8),
        9: colorScheme.primary,
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
              style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
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
