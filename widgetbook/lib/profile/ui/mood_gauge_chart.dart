import 'package:flutter/material.dart';
import 'package:teja/presentation/profile/ui/mood_gauge_chart.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Average Mood 3.0',
  type: MoodGaugeChart,
)
Widget buildAverageMood3UseCase(BuildContext context) {
  return const MoodGaugeChart(
    averageMood: 3.0,
    moodCounts: {1: 10, 2: 15, 3: 30, 4: 20, 5: 25},
    title: "Mood Distribution",
  );
}

@widgetbook.UseCase(
  name: 'Average Mood 4.5',
  type: MoodGaugeChart,
)
Widget buildAverageMood45UseCase(BuildContext context) {
  return const MoodGaugeChart(
    averageMood: 4.5,
    moodCounts: {1: 5, 2: 10, 3: 10, 4: 25, 5: 100},
    title: "Mood Distribution",
  );
}

@widgetbook.UseCase(
  name: 'All Mood Counts Zero',
  type: MoodGaugeChart,
)
Widget buildAllMoodsZeroUseCase(BuildContext context) {
  return const MoodGaugeChart(
    averageMood: 0.0,
    moodCounts: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
    title: "Mood Distribution",
  );
}

@widgetbook.UseCase(
  name: 'Average Mood 1.5',
  type: MoodGaugeChart,
)
Widget buildAverageMood15UseCase(BuildContext context) {
  return const MoodGaugeChart(
    averageMood: 1.5,
    moodCounts: {1: 30, 2: 20, 3: 15, 4: 10, 5: 5},
    title: "Mood Distribution",
  );
}
