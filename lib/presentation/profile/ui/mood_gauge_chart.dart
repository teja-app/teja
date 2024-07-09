import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teja/presentation/profile/ui/MoodGaugePainter.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        AspectRatio(
          aspectRatio: 400 / 340,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  CustomPaint(
                    painter: MoodGaugePainter(
                      averageMood: averageMood,
                      moodCounts: moodCounts,
                      isDarkMode: isDarkMode,
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),
                  Positioned(
                    bottom: constraints.maxHeight * 0.05,
                    left: 0,
                    right: 0,
                    child: _buildMoodIconsAndCounts(isDarkMode, constraints),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoodIconsAndCounts(bool isDarkMode, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return Column(
          children: [
            _buildMoodIcon(index + 1, isDarkMode, constraints),
            SizedBox(height: constraints.maxHeight * 0.02),
            Text(
              '${moodCounts[index + 1] ?? 0}',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: constraints.maxWidth * 0.03,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMoodIcon(int moodRating, bool isDarkMode, BoxConstraints constraints) {
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    final double iconSize = constraints.maxWidth * 0.05; // 5% of the width
    return SvgPicture.asset(
      'icons/mood_${moodRating}_inactive.svg',
      package: "assets",
      width: iconSize,
      height: iconSize,
      color: iconColor,
    );
  }
}
