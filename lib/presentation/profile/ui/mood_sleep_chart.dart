// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:teja/shared/common/bento_box.dart';
// import 'package:teja/shared/common/flexible_height_box.dart';

// class MoodSleepChart extends StatefulWidget {
//   final List<FlSpot> sleepData;
//   final List<FlSpot> moodData;

//   MoodSleepChart({Key? key, required this.moodData, required this.sleepData})
//       : super(key: key);

//   @override
//   _MoodSleepChartState createState() => _MoodSleepChartState();
// }

// class _MoodSleepChartState extends State<MoodSleepChart> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("widget ${widget.moodData}");
//     print("widget ${widget.sleepData}");

//     return FlexibleHeightBox(
//       gridWidth: 4,
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(
//               'Mood and Sleep',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 10),
//           BentoBox(
//             gridWidth: 4,
//             gridHeight: 2.8,
//             margin: 0,
//             padding: 0,
//             color: Theme.of(context).colorScheme.background,
//             child: AspectRatio(
//               aspectRatio: 1.70,
//               child: LineChart(
//                 LineChartData(
//                   lineTouchData: const LineTouchData(enabled: false),
//                   gridData: FlGridData(
//                     show: true,
//                     drawHorizontalLine: true,
//                     drawVerticalLine: true,
//                     getDrawingHorizontalLine: (value) => const FlLine(
//                       color: Colors.grey,
//                       strokeWidth: 1,
//                     ),
//                     getDrawingVerticalLine: (value) => const FlLine(
//                       color: Colors.grey,
//                       strokeWidth: 1,
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 22,
//                           getTitlesWidget: (double value, TitleMeta meta) {
//                             String text;
//                             switch (value.toInt()) {
//                               case 1:
//                                 text = '1';
//                                 break;
//                               case 2:
//                                 text = '2';
//                                 break;
//                               case 3:
//                                 text = '3';
//                                 break;
//                               case 4:
//                                 text = '4';
//                                 break;
//                               case 5:
//                                 text = '5';
//                                 break;
//                               case 6:
//                                 text = '6';
//                                 break;
//                               case 7:
//                                 text = '7';
//                                 break;
//                               case 8:
//                                 text = '8';
//                                 break;
//                               case 9:
//                                 text = '9';
//                                 break;
//                               case 10:
//                                 text = '10';
//                                 break;
//                               case 11:
//                                 text = '11';
//                                 break;
//                               // write till 31
//                               case 12:
//                                 text = '12';
//                                 break;
//                               case 13:
//                                 text = '13';
//                                 break;
//                               case 14:
//                                 text = '14';
//                                 break;
//                               case 15:
//                                 text = '15';
//                                 break;
//                               case 16:
//                                 text = '16';
//                                 break;
//                               case 17:
//                                 text = '17';
//                                 break;
//                               case 18:
//                                 text = '18';
//                                 break;
//                               case 19:
//                                 text = '19';
//                                 break;
//                               case 20:
//                                 text = '20';
//                                 break;
//                               case 21:
//                                 text = '21';
//                                 break;
//                               case 22:
//                                 text = '22';
//                                 break;
//                               case 23:
//                                 text = '23';
//                                 break;
//                               case 24:
//                                 text = '24';
//                                 break;
//                               case 25:
//                                 text = '25';
//                                 break;
//                               case 26:
//                                 text = '26';
//                                 break;
//                               case 27:
//                                 text = '27';
//                                 break;
//                               case 28:
//                                 text = '28';
//                                 break;
//                               case 29:
//                                 text = '29';
//                                 break;
//                               case 30:
//                                 text = '30';
//                                 break;
//                               case 31:
//                                 text = '31';
//                                 break;
//                               default:
//                                 text = '';
//                             }
//                             return SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(text),
//                             );
//                           }),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           return SideTitleWidget(
//                             axisSide: meta.axisSide,
//                             child: Text(value.toInt().toString()),
//                           );
//                         },
//                         reservedSize: 28,
//                       ),
//                     ),
//                     rightTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           return SideTitleWidget(
//                             axisSide: meta.axisSide,
//                             child: Text('${value.toInt()}h'),
//                           );
//                         },
//                         reservedSize: 28,
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(
//                       color: Colors.grey.withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   minX: 1,
//                   maxX: 30,
//                   minY: 0,
//                   maxY: 24,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: widget.moodData,
//                       isCurved: true,
//                       gradient: LinearGradient(
//                         colors: [Colors.blue, Colors.blue.withOpacity(0.3)],
//                         stops: const [0.5, 1],
//                       ),
//                       barWidth: 5,
//                       isStrokeCapRound: true,
//                       dotData: const FlDotData(show: false),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.withOpacity(0.3),
//                             Colors.blue.withOpacity(0.1)
//                           ],
//                           stops: const [0.5, 1],
//                         ),
//                       ),
//                     ),
//                     LineChartBarData(
//                       spots: widget.sleepData,
//                       isCurved: true,
//                       gradient: LinearGradient(
//                         colors: [Colors.red, Colors.red.withOpacity(0.3)],
//                         stops: const [0.5, 1],
//                       ),
//                       barWidth: 5,
//                       isStrokeCapRound: true,
//                       dotData: const FlDotData(show: false),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.red.withOpacity(0.3),
//                             Colors.red.withOpacity(0.1)
//                           ],
//                           stops: const [0.5, 1],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:teja/shared/common/bento_box.dart';
// import 'package:teja/shared/common/flexible_height_box.dart';

// class MoodSleepChart extends StatefulWidget {
//   final List<ScatterSpot> scatterData;

//   MoodSleepChart({Key? key, required this.scatterData}) : super(key: key);

//   @override
//   _MoodSleepChartState createState() => _MoodSleepChartState();
// }

// class _MoodSleepChartState extends State<MoodSleepChart> {
//   @override
//   Widget build(BuildContext context) {
//     print("widget ${widget.scatterData}");
//     return FlexibleHeightBox(
//       gridWidth: 4,
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(
//               'Mood and Sleep',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 10),
//           BentoBox(
//             gridWidth: 4,
//             gridHeight: 2.8,
//             margin: 0,
//             padding: 0,
//             color: Theme.of(context).colorScheme.background,
//             child: AspectRatio(
//               aspectRatio: 1.70,
//               child: ScatterChart(
//                 ScatterChartData(
//                   scatterSpots: widget.scatterData,
//                   gridData: FlGridData(
//                     show: true,
//                     drawHorizontalLine: true,
//                     drawVerticalLine: true,
//                     getDrawingHorizontalLine: (value) => const FlLine(
//                       color: Colors.grey,
//                       strokeWidth: 1,
//                     ),
//                     getDrawingVerticalLine: (value) => const FlLine(
//                       color: Colors.grey,
//                       strokeWidth: 1,
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                           showTitles: true,
//                           reservedSize: 22,
//                           getTitlesWidget: (double value, TitleMeta meta) {
//                             return SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(value.toString()),
//                             );
//                           }),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           return SideTitleWidget(
//                             axisSide: meta.axisSide,
//                             child: Text(value.toString()),
//                           );
//                         },
//                         reservedSize: 28,
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(
//                       color: Colors.grey.withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   minX: 0,
//                   maxX: 24,
//                   minY: 0,
//                   maxY: 5, // Adjust maxY as per the scale of mood data
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:teja/shared/common/bento_box.dart';
// import 'package:teja/shared/common/flexible_height_box.dart';

// class MoodSleepChart extends StatefulWidget {
//   final List<ScatterSpot> scatterData;

//   MoodSleepChart({Key? key, required this.scatterData}) : super(key: key);

//   @override
//   _MoodSleepChartState createState() => _MoodSleepChartState();
// }

// class _MoodSleepChartState extends State<MoodSleepChart> {
//   @override
//   Widget build(BuildContext context) {
//     return FlexibleHeightBox(
//       gridWidth: 4,
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text(
//               'Mood and Sleep',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 10),
//           BentoBox(
//             gridWidth: 4,
//             gridHeight: 2.8,
//             margin: 0,
//             padding: 0,
//             color: Theme.of(context).colorScheme.background,
//             child: AspectRatio(
//               aspectRatio: 1.70,
//               child: ScatterChart(
//                 ScatterChartData(
//                   // scatterSpots: widget.scatterData,
//                   gridData: FlGridData(
//                     show: true,
//                     drawHorizontalLine: true,
//                     drawVerticalLine: true,
//                     getDrawingHorizontalLine: (value) => const FlLine(
//                       color: Colors.grey,
//                       strokeWidth: 1,
//                     ),
//                     getDrawingVerticalLine: (value) => const FlLine(
//                       color: Colors.grey,
//                       strokeWidth: 1,
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 22,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(value.toString()),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(value.toString()),
//                             ),
//                           );
//                         },
//                         reservedSize: 28,
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(
//                       color: Colors.grey.withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   minX: 0,
//                   maxX: 24,
//                   minY: 0,
//                   maxY: 5, // Adjust maxY as per the scale of mood data
//                   scatterTouchData: ScatterTouchData(
//                     enabled: true,
//                   ),
//                   // scatterSpotRadius: 8, // Adjust the size of scatter points
//                   scatterSpots: widget.scatterData.map((spot) {
//                     return ScatterSpot(
//                       spot.x,
//                       spot.y,
//                       color: spot.color,
//                       radius: 8, // Adjust the size of scatter points
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class MoodSleepChart extends StatefulWidget {
  final List<ScatterSpot> scatterData;

  MoodSleepChart({Key? key, required this.scatterData}) : super(key: key);

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
                  // scatterSpots: widget.scatterData,
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => const FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36, // Adjusted size for better visibility
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
                        // reservedSize: 36, // Adjusted size for better visibility
                        // getTitlesWidget: (double value, TitleMeta meta) {
                        //   return Padding(
                        //     padding: const EdgeInsets.only(right: 8.0),
                        //     child: SideTitleWidget(
                        //       axisSide: meta.axisSide,
                        //       child: Text(
                        //         value.toInt().toString(),
                        //         style: const TextStyle(
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // },
                        reservedSize: 36,
                        interval: 1,
                        getTitlesWidget: (value, meta) => _buildMoodIcon(
                          value.toInt(),
                          meta,
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: 24,
                  minY: 0,
                  maxY: 5, // Adjust maxY as per the scale of mood data
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
