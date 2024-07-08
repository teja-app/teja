import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teja/presentation/profile/ui/MoodGaugePainter.dart';
import 'package:teja/shared/common/bento_box.dart';

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

    return BentoBox(
      gridWidth: 6,
      gridHeight: 4,
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
              gridWidth: 6,
              gridHeight: 1.0,
              margin: 0,
              padding: 0,
              color: Theme.of(context).colorScheme.background,
              child: AspectRatio(
                aspectRatio: 400 / 340,
                child: CustomPaint(
                  painter: MoodGaugePainter(
                    averageMood: averageMood,
                    moodCounts: moodCounts,
                    isDarkMode: isDarkMode,
                  ),
                  child: Stack(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        Positioned(
                          left: 400 * (35 + (i - 1) * 65.5) / 400,
                          top: 340 * 240 / 340 - 15,
                          child: _buildMoodIcon(i, isDarkMode),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(int moodRating, bool isDarkMode) {
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    return SvgPicture.asset(
      'icons/mood_${moodRating}_inactive.svg',
      package: "assets",
      width: 20,
      height: 20,
      color: iconColor,
    );
  }
}
