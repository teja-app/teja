import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodSleepChart extends StatefulWidget {
  final List<ScatterSpot> scatterData;
  final double maxX;
  final double minY;
  final String title;

  const MoodSleepChart({
    Key? key,
    required this.scatterData,
    required this.maxX,
    required this.minY,
    required this.title,
  }) : super(key: key);

  @override
  _MoodSleepChartState createState() => _MoodSleepChartState();
}

class _MoodSleepChartState extends State<MoodSleepChart> {
  String _formatNumber(double value) {
    if (value >= 1000 && value < 1000000) {
      return value % 1000 == 0
          ? '${(value / 1000).toStringAsFixed(0)}k'
          : '${(value / 1000).toStringAsFixed(1)}k';
    } else if (value >= 1000000) {
      return value % 1000000 == 0
          ? '${(value / 1000000).toStringAsFixed(0)}M'
          : '${(value / 1000000).toStringAsFixed(1)}M';
    }
    return value.toInt().toString();
  }

  List<double> _generateDesiredValues() {
    List<double> values = [];
    double interval = widget.maxX / 5;
    for (int i = 0; i <= 5; i++) {
      values.add(i * interval);
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    List<double> desiredValues = _generateDesiredValues();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(
              right: 16.0), // Add padding to the right side
          child: Container(
            width: double.infinity, // Ensures the width is full
            constraints: const BoxConstraints(
              maxHeight: 300, // Adjusted maximum height for the chart
            ),
            child: AspectRatio(
              aspectRatio: 1.5, // Maintain aspect ratio
              child: ScatterChart(
                ScatterChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    verticalInterval: widget.maxX / 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 0.5,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 0.5,
                    ),
                    checkToShowVerticalLine: (value) {
                      return desiredValues.contains(value);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: widget.maxX /
                            5, // Adjust interval to reduce overlapping
                        reservedSize:
                            40, // Adjusted size for better visibility of bottom titles
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 1.0, right: 2.0),
                            child: SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                _formatNumber(value),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Increased size for mood icons
                        interval: 1,
                        getTitlesWidget: (value, meta) => _buildMoodIcon(
                          value.toInt(),
                          meta,
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Hide right titles
                        reservedSize: 50, // Reserve space on the right side
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Hide top titles
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 0.1,
                    ),
                  ),
                  minX: 0,
                  maxX: widget.maxX,
                  minY: widget.minY, // Adjust minY based on the provided data
                  maxY: 6, // Adjust maxY as per the scale of mood data
                  scatterTouchData: ScatterTouchData(
                    enabled: true,
                  ),
                  scatterSpots: widget.scatterData.map((spot) {
                    return ScatterSpot(
                      spot.x,
                      spot.y,
                      color: spot.color,
                      radius: spot.radius, // Adjust the size of scatter points
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildMoodIcon(int moodRating, TitleMeta meta) {
  String moodIconPath = 'assets/icons/mood_${moodRating}_inactive.svg';
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: SvgPicture.asset(
      moodIconPath,
      width: 16,
      height: 20,
    ),
  );
}
