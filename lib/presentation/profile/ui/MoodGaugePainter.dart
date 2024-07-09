import 'package:flutter/material.dart';
import 'dart:math';

class MoodGaugePainter extends CustomPainter {
  final double averageMood;
  final Map<int, int> moodCounts;
  final bool isDarkMode;

  MoodGaugePainter({
    required this.averageMood,
    required this.moodCounts,
    required this.isDarkMode,
  });

  String getMoodLabel(double averageMood) {
    if (averageMood == 0) return 'No Data';
    if (averageMood < 1.5) return 'Challenging';
    if (averageMood < 2.5) return 'Room for Improvement';
    if (averageMood < 3.5) return 'Balanced';
    if (averageMood < 4.5) return 'Positive';
    return 'Excellent';
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;
    final double centerY = height * 180 / 340;

    // Draw gauge arc
    final rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: width * 0.375);
    const gradient = SweepGradient(
      startAngle: pi,
      endAngle: 2 * pi,
      colors: [
        Color(0xFFE6E6E6),
        Color(0xFFC2C2C2),
        Color(0xFF9E9E9E),
        Color(0xFF7A7A7A),
        Color(0xFF565656),
      ],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.075;
    canvas.drawArc(rect, pi, pi, false, paint);

    // Draw mood indicator circle only if averageMood is not zero
    if (averageMood != 0) {
      final double angle = pi + (averageMood - 1) / 4 * pi;
      final double indicatorX = centerX + cos(angle) * width * 0.375;
      final double indicatorY = centerY + sin(angle) * width * 0.375;

      final indicatorPaint = Paint()
        ..color = isDarkMode ? const Color(0xFF9E9E9E) : const Color(0xFF565656)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = isDarkMode ? const Color(0xFFE6E6E6) : const Color(0xFF565656)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(indicatorX, indicatorY), width * 0.05, indicatorPaint);
      canvas.drawCircle(Offset(indicatorX, indicatorY), width * 0.05, strokePaint);
    }

    // Draw average mood text
    final textPainter = TextPainter(
      text: TextSpan(
        text: averageMood != 0 ? averageMood.toStringAsFixed(1) : 'N/A',
        style: TextStyle(
          color: isDarkMode ? const Color(0xFFE6E6E6) : const Color(0xFF565656),
          fontSize: width * 0.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, height * 140 / 340));

    // Draw mood label
    final labelText = getMoodLabel(averageMood);
    final labelPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: TextStyle(
          color: isDarkMode ? const Color(0xFFE6E6E6) : const Color(0xFF565656),
          fontSize: width * 0.035,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(centerX - labelPainter.width / 2, height * 180 / 340));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
