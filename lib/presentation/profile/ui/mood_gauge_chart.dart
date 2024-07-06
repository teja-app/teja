import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MoodGaugeChart extends StatelessWidget {
  final double averageMood;
  final Map<int, int> moodCounts;
  final String title;

  const MoodGaugeChart({
    Key? key,
    required this.averageMood,
    required this.moodCounts,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GaugeRange> dynamicRanges = _calculateDynamicRanges();

    int totalMoodCount = moodCounts.values.fold(0, (sum, count) => sum + count);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final markerColor = isDarkMode ? Colors.white : Colors.black;

    return FlexibleHeightBox(
      gridWidth: 6, // Increase chart width to 6 (adjust as needed)
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: BentoBox(
              gridWidth:
                  6, // Ensure the gridWidth matches the FlexibleHeightBox width
              gridHeight: 1.0,
              margin: 0,
              padding: 0,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  Expanded(
                    child: SfRadialGauge(
                      enableLoadingAnimation: true,
                      axes: <RadialAxis>[
                        RadialAxis(
                          startAngle: 180,
                          endAngle: 0,
                          minimum: 1,
                          maximum: 5,
                          radiusFactor: 0.9,
                          centerY: 0.55,
                          useRangeColorForAxis: true,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 30.0, // Adjust thickness as needed
                            color: dynamicRanges
                                .map((range) =>
                                    Color(range.color!.value.toInt()))
                                .toList()
                                .first,
                            gradient: SweepGradient(
                              colors: dynamicRanges
                                  .map((range) => range.color!)
                                  .toList(),
                            ),
                          ),
                          pointers: [
                            MarkerPointer(
                              value: averageMood,
                              markerType: MarkerType.invertedTriangle,
                              color: markerColor,
                              markerHeight: 20,
                              markerWidth: 20,
                              enableAnimation: true,
                              markerOffset: -20,
                            ),
                          ],
                          annotations: [
                            GaugeAnnotation(
                              widget: Text(
                                '$totalMoodCount',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: markerColor,
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.0,
                            ),
                            GaugeAnnotation(
                              widget: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (int i = 5; i >= 1; i--)
                                    _buildMoodIconWithBadge(
                                        i, moodCounts[i] ?? 0),
                                ],
                              ),
                              angle: 90,
                              positionFactor: 1.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<GaugeRange> _calculateDynamicRanges() {
    List<GaugeRange> ranges = [];

    // Calculate total count of moods
    int totalCount = moodCounts.values.fold(0, (sum, count) => sum + count);

    // Avoid division by zero
    if (totalCount == 0) {
      // Add a default range to avoid errors
      ranges.add(
        GaugeRange(
          startValue: 1.0,
          endValue: 5.0,
          color: Colors.grey,
        ),
      );
      return ranges;
    }

    // Calculate percentages for each mood segment
    double percentage0to1 = (moodCounts[1] ?? 0) / totalCount;
    double percentage1to2 = (moodCounts[2] ?? 0) / totalCount;
    double percentage2to3 = (moodCounts[3] ?? 0) / totalCount;
    double percentage3to4 = (moodCounts[4] ?? 0) / totalCount;
    double percentage4to5 = (moodCounts[5] ?? 0) / totalCount;

    // Calculate end values for each mood segment
    double endValue0to1 =
        1.0 + percentage0to1 * 5.0; // Adjusting ranges to fit 1-5 scale
    double endValue1to2 = endValue0to1 + percentage1to2 * 5.0;
    double endValue2to3 = endValue1to2 + percentage2to3 * 5.0;
    double endValue3to4 = endValue2to3 + percentage3to4 * 5.0;
    double endValue4to5 = endValue3to4 + percentage4to5 * 5.0;

    // Create ranges for each mood segment only if they have value
    if (percentage0to1 > 0) {
      ranges.add(
        GaugeRange(
          startValue: 1.0,
          endValue: endValue0to1,
          color: _getMoodColor(1.5), // Color for 1-2 (super good)
        ),
      );
    }
    if (percentage1to2 > 0) {
      ranges.add(
        GaugeRange(
          startValue: endValue0to1,
          endValue: endValue1to2,
          color: _getMoodColor(2.5), // Color for 2-3 (normal)
        ),
      );
    }
    if (percentage2to3 > 0) {
      ranges.add(
        GaugeRange(
          startValue: endValue1to2,
          endValue: endValue2to3,
          color: _getMoodColor(3.5), // Color for 3-4 (bad)
        ),
      );
    }
    if (percentage3to4 > 0) {
      ranges.add(
        GaugeRange(
          startValue: endValue2to3,
          endValue: endValue3to4,
          color: _getMoodColor(4.5), // Color for 4-5 (no feelings)
        ),
      );
    }
    if (percentage4to5 > 0) {
      ranges.add(
        GaugeRange(
          startValue: endValue3to4,
          endValue: endValue4to5,
          color: _getMoodColor(5.5), // Color for 5-6 (Terrible)
        ),
      );
    }

    return ranges;
  }

  Color _getMoodColor(double moodRating) {
    if (moodRating <= 1.5) {
      return Colors.red;
    } else if (moodRating <= 2.5) {
      return Colors.orange;
    } else if (moodRating <= 3.5) {
      return Colors.yellow;
    } else if (moodRating <= 4.5) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  Widget _buildMoodIconWithBadge(int moodRating, int count) {
    String moodIconPath = 'assets/icons/mood_${moodRating}_inactive.svg';
    return Column(
      children: [
        Stack(
          children: [
            SvgPicture.asset(
              moodIconPath,
              width: 40,
              height: 40,
              color: _getMoodColor(moodRating.toDouble()),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getMoodColor(moodRating.toDouble()),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(_getMoodLabel(moodRating)),
      ],
    );
  }

  String _getMoodLabel(int moodRating) {
    switch (moodRating) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Good';
      case 3:
        return 'Normal';
      case 2:
        return 'Bad';
      case 1:
        return 'Terrible';
      default:
        return '';
    }
  }
}
