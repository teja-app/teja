import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class HeatMapComponent extends StatelessWidget {
  final String title; // Define a field to hold the title
  final Map<DateTime, int> dataset;

  const HeatMapComponent({Key? key, required this.title, required this.dataset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).colorScheme.brightness;
    var weekTextColor = Colors.black;
    var defaultColor = Colors.grey[200];
    var textColor = Colors.grey[100];
    if (brightness == Brightness.dark) {
      weekTextColor = Colors.white;
      defaultColor = Colors.grey[800];
      textColor = Colors.grey[800];
    }

    return FlexibleHeightBox(
      gridWidth: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              title, // Use the title passed from props
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          BentoBox(
            gridWidth: 4,
            gridHeight: 3,
            margin: 0,
            padding: 0,
            color: Theme.of(context).colorScheme.background,
            child: HeatMapCalendar(
              initDate: DateTime.now(),
              datasets: dataset,
              colorMode: ColorMode.opacity, // Use opacity for color mode
              colorsets: {
                0: Colors.blue[700]!,
                // Add more colors as needed
              },
              defaultColor: defaultColor,
              textColor: textColor,
              showColorTip: false,
              size: 30,
              monthFontSize: 14, // Adjust the size of the month label
              weekFontSize: 12, // Adjust the size of the week label
              weekTextColor: weekTextColor,
              borderRadius: 5,
              margin: const EdgeInsets.all(2),
            ),
          ),
        ],
      ),
    );
  }
}
