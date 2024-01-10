// lib/presentation/home/ui/mood/mood_tracker.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_state.dart';
import 'package:teja/presentation/mood/ui/mood_detail_card.dart';
import 'package:teja/presentation/mood/ui/mood_selection_component.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class CombinedModel {
  final MoodLogsState moodLogsState;
  final DateTime? selectedDate;

  CombinedModel({
    required this.moodLogsState,
    this.selectedDate,
  });
}

class MoodTrackerWidget extends StatefulWidget {
  const MoodTrackerWidget({super.key});

  @override
  MoodTrackerWidgetState createState() => MoodTrackerWidgetState();
}

class MoodTrackerWidgetState extends State<MoodTrackerWidget> {
  bool _showMoods = false;
  int? _selectedMoodIndex; // To track the selected mood

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      store.dispatch(const FetchMoodLogsAction());
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    _showMoods = false;
    _selectedMoodIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, CombinedModel>(
      converter: (store) => CombinedModel(
        moodLogsState: store.state.moodLogsState,
        selectedDate: store.state.homeState.selectedDate,
      ),
      builder: (_, combinedModel) {
        String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(combinedModel.selectedDate!);

        List<MoodLogEntity>? moodLogsForSelectedDate =
            combinedModel.moodLogsState.moodLogsByDate[formattedSelectedDate];

        // Check if mood logs exist for the selected date and update _showMoods accordingly
        if (moodLogsForSelectedDate != null && moodLogsForSelectedDate.isNotEmpty) {
          if (!_showMoods) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _showMoods = true;
                });
              }
            });
          }
        }

        return Column(
          children: [
            // Display mood logs layout if they exist
            if (_showMoods && moodLogsForSelectedDate != null && moodLogsForSelectedDate.isNotEmpty)
              _moodLogsLayout(moodLogsForSelectedDate),
            // Show the mood tracker layout
            _moodTrackerLayout(context, combinedModel.selectedDate!),
          ],
        );
      },
    );
  }

  Widget _moodLogsLayout(List<MoodLogEntity> moodLogs) {
    return ListView.builder(
      shrinkWrap: true, // Allows ListView to determine its own height
      physics: const NeverScrollableScrollPhysics(), // Disables scrolling within ListView
      itemCount: moodLogs.length,
      itemBuilder: (itemBuildContext, index) {
        return moodLogLayout(moodLogs[index], context);
      },
    );
  }

  void _handleMoodSelected(int moodIndex) {
    setState(() {
      _selectedMoodIndex = moodIndex;
    });
  }

  Widget _moodTrackerLayout(BuildContext context, DateTime selectedDate) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 400,
      height: 200,
      child: Stack(
        children: [
          if (!_showMoods)
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/background/MoodTrack.svg',
                fit: BoxFit.cover,
              ),
            ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showMoods
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'How are you feeling now?',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    MoodSelectionComponent(
                      onMoodSelected: _handleMoodSelected,
                    ),
                    if (_selectedMoodIndex != null) ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button(
                            text: "Continue",
                            buttonType: ButtonType.primary,
                            icon: AntDesign.caretright,
                            onPressed: () {
                              if (_selectedMoodIndex != null) {
                                final store = StoreProvider.of<AppState>(context);
                                store.dispatch(TriggerSelectMoodAction(
                                  moodRating: _selectedMoodIndex!,
                                  timestamp: selectedDate,
                                ));
                                store.dispatch(const ChangePageAction(1));
                                _selectedMoodIndex = null;
                                _showMoods = false;
                                GoRouter.of(context).pushNamed(RootPath.moodEdit);
                              }
                            },
                          ),
                          Button(
                            text: "Done",
                            icon: AntDesign.check,
                            buttonType: ButtonType.secondary,
                            onPressed: () {
                              if (_selectedMoodIndex != null) {
                                final store = StoreProvider.of<AppState>(context);
                                store.dispatch(TriggerSelectMoodAction(
                                  moodRating: _selectedMoodIndex!,
                                  timestamp: selectedDate,
                                ));
                                _selectedMoodIndex = null;
                                _showMoods = false;
                                // Dispatch any other action if needed for 'Done' functionality
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ]))
                : _initialLayout(),
          ),
        ],
      ),
    );
  }

  Widget _initialLayout() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Mood and Emotions', style: textTheme.titleSmall),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.check, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Track Mood', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              Text('How do you feel today?', style: textTheme.titleSmall),
              const SizedBox(height: 12),
              Button(
                text: "Let's Begin",
                buttonType: ButtonType.primary,
                onPressed: () {
                  setState(() {
                    _showMoods = true;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
