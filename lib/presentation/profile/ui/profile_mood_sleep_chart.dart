import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/profile/ui/mood_sleep_chart.dart';
import 'package:teja/presentation/profile/ui/checklist.dart';

class MoodSleepChartScreen extends StatefulWidget {
  const MoodSleepChartScreen({super.key});

  @override
  State<MoodSleepChartScreen> createState() => _MoodSleepChartScreenState();
}

class _MoodSleepChartScreenState extends State<MoodSleepChartScreen> {
  late MoodSleepChartViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime now = DateTime.now();
      final DateTime today =
          DateTime(now.year, now.month, now.day); // Reset time to midnight
      StoreProvider.of<AppState>(context)
          .dispatch(FetchMonthlyMoodReportAction(today));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MoodSleepChartViewModel>(
      converter: (store) {
        final viewModel = MoodSleepChartViewModel.fromStore(store);
        return viewModel;
      },
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Checklist(
          componentName: MOOD_SLEEP_CHART,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 350),
            child: MoodSleepChart(
              key: const Key('MoodSleepChartScreen'),
              title: "Mood & Sleep",
              scatterData: viewModel.scatterData,
              maxX: viewModel.scatterData.isNotEmpty
                  ? viewModel.scatterData.map((spot) => spot.x).reduce(
                          (value, element) =>
                              value > element ? value : element) +
                      viewModel.scatterData.map((spot) => spot.x).reduce(
                          (value, element) => value < element ? value : element)
                  : 20,
              minY: viewModel.scatterData.isNotEmpty
                  ? viewModel.scatterData.map((spot) => spot.y).reduce(
                          (value, element) =>
                              value < element ? value : element) -
                      4
                  : 0,
            ),
          ),
        );
      },
    );
  }
}

class MoodSleepChartViewModel {
  final bool isLoading;
  List<ScatterSpot> scatterData;

  MoodSleepChartViewModel({
    required this.isLoading,
    required this.scatterData,
  });

  factory MoodSleepChartViewModel.fromStore(Store<AppState> store) {
    final state = store.state.monthlyMoodReportState;

    return MoodSleepChartViewModel(
      isLoading: state.isLoading,
      scatterData: state.scatterSpots,
    );
  }
}
