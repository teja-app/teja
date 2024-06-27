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
          : _buildBody(vm, context),
    );
  }

  Widget _buildBody(_ViewModel vm, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...vm.chartSequence
              .map((chart) => _buildChart(context, chart))
              .toList(),
          const SizedBox(height: 20), // Add some space before the button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextButton(
              onPressed: () => _showReorderBottomSheet(context, vm),
              style: TextButton.styleFrom(
                // primary: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Personalise'),
            ),
          ),
        ],
      ),
    );
  }

  void _showReorderBottomSheet(BuildContext context, _ViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      useSafeArea: true,
      builder: (BuildContext context) {
        return StoreConnector<AppState, List<String>>(
          converter: (store) => store.state.profilePageState.chartSequence,
          builder: (context, chartSequence) {
            return Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Theme.of(context).textTheme.bodyLarge?.color,
                      displayColor:
                          Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                iconTheme: IconThemeData(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  vm.updateChartSequence(oldIndex, newIndex);
                },
                children: chartSequence.map((chart) {
                  return ListTile(
                    key: Key(chart),
                    title: Text(_getChartDisplayName(chart)),
                    leading: const Icon(Icons.drag_handle),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  String _getChartDisplayName(String chartName) {
    switch (chartName) {
      case 'MoodSleepChartScreen':
        return 'Mood Sleep Chart';
      case 'ProfileSleepHeatMapScreen':
        return 'Sleep Heat Map';
      case 'ProfileMoodYearlyHeatMapScreen':
        return 'Mood Yearly Heat Map';
      case 'ProfileMoodActivityScreen':
        return 'Mood Activity Chart';
      default:
        return 'Unknown Chart';
    }
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

// _ViewModel class remains the same