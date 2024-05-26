import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class MoodSleepChart extends StatefulWidget {
  final List<ScatterSpot> scatterData;
  final double maxX;

  const MoodSleepChart(
      {Key? key, required this.scatterData, required this.maxX})
      : super(key: key);

  @override
  _MoodSleepChartState createState() => _MoodSleepChartState();
}

class _MoodSleepChartState extends State<MoodSleepChart> {
  @override
  Widget build(BuildContext context) {
    return FlexibleHeightBox(
      gridWidth: 4,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Mood and Sleep',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          BentoBox(
            gridWidth: 4,
            gridHeight: 2.8,
            margin: 0,
            padding: 0,
            color: Theme.of(context).colorScheme.background,
            child: AspectRatio(
              aspectRatio: 1.70,
              child: ScatterChart(
                ScatterChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 0.5,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 0.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 46, // Adjusted size for better visibility
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                value.toInt().toString(),
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
                        reservedSize: 36,
                        interval: 1,
                        getTitlesWidget: (value, meta) => _buildMoodIcon(
                          value.toInt(),
                          meta,
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: const Text(
                                "",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: const Text(
                                "",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
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
                  minY: 0,
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
        ],
      ),
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
