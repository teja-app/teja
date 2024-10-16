import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_actions.dart';
import 'package:teja/presentation/profile/ui/profile_heat_map.dart';
import 'package:teja/presentation/profile/ui/profile_mood_activity_screen.dart';
import 'package:teja/presentation/profile/ui/profile_mood_gauge.dart';
import 'package:teja/presentation/profile/ui/profile_mood_sleep_chart.dart';
import 'package:teja/presentation/profile/ui/profile_mood_yearly_heatmap.dart';
import 'package:teja/shared/common/button.dart';
import 'dart:io' show Platform;

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(FetchChartSequenceAction());
      },
      builder: (context, vm) =>
          vm.isLoading ? const Center(child: CircularProgressIndicator()) : _buildBody(vm, context),
    );
  }

  Widget _buildBody(_ViewModel vm, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...vm.chartSequence.map((chart) => _buildChart(context, chart)).toList(),
          const SizedBox(height: 20), // Add some space before the button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Button(
              onPressed: () => _showReorderBottomSheet(context, vm),
              icon: AntDesign.setting,
              text: 'Personalise',
            ),
          ),
        ],
      ),
    );
  }

  void _showReorderBottomSheet(BuildContext context, _ViewModel vm) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      useSafeArea: true,
      builder: (BuildContext context) {
        return StoreConnector<AppState, List<String>>(
          converter: (store) => store.state.profilePageState.chartSequence,
          builder: (context, chartSequence) {
            // Filter out unavailable charts for Android
            final availableCharts = Platform.isAndroid
                ? chartSequence
                    .where((chart) =>
                        chart != 'MoodSleepChartScreen' &&
                        chart != 'ProfileSleepHeatMapScreen' &&
                        chart != 'ProfileMoodActivityScreen')
                    .toList()
                : chartSequence;

            return ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                // Adjust indices if necessary due to filtered list
                final actualOldIndex = chartSequence.indexOf(availableCharts[oldIndex]);
                final actualNewIndex = chartSequence.indexOf(availableCharts[newIndex]);
                vm.updateChartSequence(actualOldIndex, actualNewIndex);
              },
              children: availableCharts.map((chart) {
                return ListTile(
                  key: Key(chart),
                  title: Text(_getChartDisplayName(chart)),
                  leading: const Icon(Icons.drag_handle),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  String _getChartDisplayName(String chartName) {
    switch (chartName) {
      case 'MoodSleepChartScreen':
        return 'Mood-Sleep Correlation Chart';
      case 'ProfileSleepHeatMapScreen':
        return 'Sleep Tracker Calendar';
      case 'ProfileMoodYearlyHeatMapScreen':
        return 'Emotion Tracker';
      case 'ProfileMoodActivityScreen':
        return 'Mood-Walk Correlation';
      case 'MoodSemiCircleChartScreen':
        return 'Mood Compass';
      default:
        return 'Unknown Chart';
    }
  }

  Widget _buildChart(BuildContext context, String chartName) {
    if (Platform.isAndroid &&
        (chartName == 'MoodSleepChartScreen' ||
            chartName == 'ProfileSleepHeatMapScreen' ||
            chartName == 'ProfileMoodActivityScreen')) {
      return Container(); // Return an empty container for Android
    }

    switch (chartName) {
      case 'MoodSleepChartScreen':
        return const MoodSleepChartScreen(key: Key('MoodSleepChartScreen'));
      case 'ProfileSleepHeatMapScreen':
        return const ProfileSleepHeatMapScreen(key: Key('ProfileSleepHeatMapScreen'));
      case 'ProfileMoodYearlyHeatMapScreen':
        return const ProfileMoodYearlyHeatMapScreen(key: Key('ProfileMoodYearlyHeatMapScreen'));
      case 'ProfileMoodActivityScreen':
        return const MoodActivityChartScreen(key: Key('ProfileMoodActivityScreen'));
      case 'MoodSemiCircleChartScreen':
        return const MoodSemiCircleChartScreen(key: Key('MoodSemiCircleChartScreen'));
      default:
        return Container(
          key: Key('defaultChart $chartName'),
          child: const Text('Unknown Chart'),
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
        final updatedSequence = List<String>.from(store.state.profilePageState.chartSequence);
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

// _ViewModel class remains the same