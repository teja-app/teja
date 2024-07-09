import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/profile/ui/mood_gauge_chart.dart';
import 'package:teja/presentation/profile/ui/checklist.dart';

class MoodSemiCircleChartScreen extends StatefulWidget {
  const MoodSemiCircleChartScreen({super.key});

  @override
  State<MoodSemiCircleChartScreen> createState() => _MoodSemiCircleChartScreenState();
}

class _MoodSemiCircleChartScreenState extends State<MoodSemiCircleChartScreen> {
  late MoodSemiCircleChartViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      StoreProvider.of<AppState>(context).dispatch(FetchMonthlyMoodReportAction(today));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MoodSemiCircleChartViewModel>(
      converter: (store) => MoodSemiCircleChartViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Checklist(
          componentName: MOOD_GAUGE_CHART,
          child: MoodGaugeChart(
            averageMood: viewModel.averageMood,
            moodCounts: viewModel.moodCounts,
            title: 'Mood Gauge Chart',
          ),
        );
      },
    );
  }
}

class MoodSemiCircleChartViewModel {
  final bool isLoading;
  final double averageMood;
  final Map<int, int> moodCounts;

  MoodSemiCircleChartViewModel({
    required this.isLoading,
    required this.averageMood,
    required this.moodCounts,
  });

  factory MoodSemiCircleChartViewModel.fromStore(Store<AppState> store) {
    final state = store.state.monthlyMoodReportState;

    double averageMood = 0;
    if (state.currentMonthAverageMoodRatings.isNotEmpty) {
      averageMood = state.currentMonthAverageMoodRatings.values.reduce((a, b) => a + b) /
          state.currentMonthAverageMoodRatings.length;
    }

    Map<int, int> moodCounts = {};
    for (final mood in state.currentMonthAverageMoodRatings.values) {
      moodCounts[mood.toInt()] = moodCounts[mood.toInt()] == null ? 1 : moodCounts[mood.toInt()]! + 1;
    }

    return MoodSemiCircleChartViewModel(
      isLoading: state.isLoading,
      averageMood: averageMood,
      moodCounts: moodCounts,
    );
  }
}
