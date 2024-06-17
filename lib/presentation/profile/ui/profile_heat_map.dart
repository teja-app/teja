import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_actions.dart';
import 'package:teja/presentation/profile/ui/checklist.dart';
import 'package:teja/presentation/profile/ui/heat_map_chart.dart';

class ProfileSleepHeatMapScreen extends StatefulWidget {
  const ProfileSleepHeatMapScreen({super.key});

  @override
  State<ProfileSleepHeatMapScreen> createState() => _ProfileSleepHeatMapScreenState();
}

class _ProfileSleepHeatMapScreenState extends State<ProfileSleepHeatMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day); // Reset time to midnight
      StoreProvider.of<AppState>(context).dispatch(FetchYearlySleepReportAction(today));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SleepHeatMapViewModel>(
      converter: (store) {
        final viewModel = SleepHeatMapViewModel.fromStore(store);
        return viewModel;
      },
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Checklist(
          componentName: SLEEP_HEAT_MAP,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: HeatMapComponent(
              key: const Key('heatMapComponent'),
              dataset: viewModel.dataset,
              title: "Sleep Heat Map",
            ),
          ),
        );
      },
    );
  }
}

class SleepHeatMapViewModel {
  final bool isLoading;
  final Map<DateTime, int> dataset;

  SleepHeatMapViewModel({
    required this.isLoading,
    required this.dataset,
  });

  factory SleepHeatMapViewModel.fromStore(Store<AppState> store) {
    final state = store.state.yearlySleepReportState;
    return SleepHeatMapViewModel(
      isLoading: state.isLoading,
      dataset: state.yearlySleepData,
    );
  }
}
