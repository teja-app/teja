import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_actions.dart';
import 'package:teja/presentation/profile/ui/checklist.dart';
import 'package:teja/presentation/profile/ui/heat_map_chart.dart';

class ProfileMoodYearlyHeatMapScreen extends StatefulWidget {
  const ProfileMoodYearlyHeatMapScreen({super.key});

  @override
  State<ProfileMoodYearlyHeatMapScreen> createState() =>
      _ProfileMoodYearlyHeatMapScreenState();
}

class _ProfileMoodYearlyHeatMapScreenState
    extends State<ProfileMoodYearlyHeatMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime now = DateTime.now();
      final DateTime today =
          DateTime(now.year, now.month, now.day); // Reset time to midnight
      StoreProvider.of<AppState>(context)
          .dispatch(FetchYearlyMoodReportAction(today));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MoodYearlyHeatMapViewModel>(
      converter: (store) {
        final viewModel = MoodYearlyHeatMapViewModel.fromStore(store);
        return viewModel;
      },
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Checklist(
          componentName: MOOD_HEAT_MAP,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: HeatMapComponent(
              key: const Key('ProfileMoodYearlyHeatMapScreen'),
              dataset: viewModel.dataset,
              title: "Mood Heat Map",
            ),
          ),
        );
      },
    );
  }
}

class MoodYearlyHeatMapViewModel {
  final bool isLoading;
  final Map<DateTime, int> dataset;

  MoodYearlyHeatMapViewModel({
    required this.isLoading,
    required this.dataset,
  });

  factory MoodYearlyHeatMapViewModel.fromStore(Store<AppState> store) {
    final state = store.state.yearlyMoodReportState;
    return MoodYearlyHeatMapViewModel(
      isLoading: state.isLoading,
      dataset: state.currentYearAverageMoodRatings,
    );
  }
}
