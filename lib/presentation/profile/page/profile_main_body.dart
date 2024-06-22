import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_actions.dart';
import 'package:teja/presentation/profile/ui/profile_heat_map.dart';
import 'package:teja/presentation/profile/ui/profile_mood_activity_screen.dart';
import 'package:teja/presentation/profile/ui/profile_mood_sleep_chart.dart';
import 'package:teja/presentation/profile/ui/profile_mood_yearly_heatmap.dart';

class MainBody extends StatelessWidget {
  const MainBody();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, vm) => vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildReorderableList(vm, context),
    );
  }

  Widget _buildReorderableList(_ViewModel vm, BuildContext context) {
    return ReorderableListView.builder(
      scrollController: ScrollController(), // Adjust initialization as needed
      onReorder: vm.updateChartSequence,
      // children:
      //     vm.chartSequence.map((chart) => _buildChart(context, chart)).toList(),
      itemCount: vm.chartSequence.length,
      itemBuilder: (context, index) =>
          _buildChart(context, vm.chartSequence[index]),
    );
  }

  Widget _buildChart(BuildContext context, String chartName) {
    switch (chartName) {
      case 'MoodSleepChartScreen':
        return const MoodSleepChartScreen(key: Key('MoodSleepChartScreen'));
      case 'ProfileSleepHeatMapScreen':
        return const ProfileSleepHeatMapScreen(
            key: Key('ProfileSleepHeatMapScreen'));
      case 'ProfileMoodYearlyHeatMapScreen':
        return const ProfileMoodYearlyHeatMapScreen(
            key: Key('ProfileMoodYearlyHeatMapScreen'));
      case 'ProfileMoodActivityScreen':
        return const MoodActivityChartScreen(
            key: Key('ProfileMoodActivityScreen'));
      default:
        return Container(
          key: Key('defaultChart'),
          child:
              const Text('Unknown Chart'), // Placeholder for unknown chart type
        );
    }
  }
}

class _ViewModel {
  final bool isLoading;
  final List<String> chartSequence;
  final Function(int oldIndex, int newIndex) updateChartSequence;

  _ViewModel({
    required this.isLoading,
    required this.chartSequence,
    required this.updateChartSequence,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoading: store.state.profilePageState.isLoading,
      chartSequence: store.state.profilePageState.chartSequence,
      updateChartSequence: (oldIndex, newIndex) {
        final updatedSequence =
            List<String>.from(store.state.profilePageState.chartSequence);
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = updatedSequence.removeAt(oldIndex);
        updatedSequence.insert(newIndex, item);
        store.dispatch(UpdateChartSequenceAction(updatedSequence));
      },
    );
  }
}
