import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class HeatMapComponent extends StatelessWidget {
  final Map<DateTime, int> dataset;

  const HeatMapComponent({Key? key, required this.dataset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleHeightBox(
      gridWidth: 4,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              'Heat Map',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          BentoBox(
            gridWidth: 4,
            gridHeight: 3,
            margin: 0,
            padding: 0,
            color: Theme.of(context).colorScheme.background,
            child: HeatMap(
              startDate: DateTime(2024, 1, 1),
              endDate: DateTime(2024, 12, 31),
              datasets: dataset,
              colorMode: ColorMode.opacity, // Use opacity for color mode
              colorsets: {
                0: Colors.blue[700]!,
                // Add more colors as needed
              },
              defaultColor: Colors.grey[200]!,
              textColor: Colors.white,
              showColorTip: false,
              scrollable: true,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
