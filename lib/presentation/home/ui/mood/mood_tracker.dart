// lib/presentation/home/ui/mood/mood_tracker.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/home/home_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_state.dart';
import 'package:teja/presentation/mood/ui/mood_selection_component.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class CombinedModel {
  final MoodLogsState moodLogsState;
  final HomeState homeState;

  CombinedModel({
    required this.moodLogsState,
    required this.homeState,
  });
}

class MoodTrackerWidget extends StatefulWidget {
  const MoodTrackerWidget({super.key});

  @override
  _MoodTrackerWidgetState createState() => _MoodTrackerWidgetState();
}

class _MoodTrackerWidgetState extends State<MoodTrackerWidget> {
  bool _showMoods = false;
  int? _selectedMoodIndex; // To track the selected mood

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      // Dispatch the action to fetch mood logs here
      store.dispatch(FetchMoodLogsAction());
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
    return StoreConnector<AppState, CombinedModel>(
      converter: (store) => CombinedModel(
        moodLogsState: store.state.moodLogsState,
        homeState: store.state.homeState,
      ),
      builder: (_, combinedModel) {
        // Assume we have a way to get the currently selected date
        String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(combinedModel.homeState.selectedDate!);
        MoodLogEntity? selectedDateMoodLog = combinedModel.moodLogsState.moodLogsByDate[formattedSelectedDate];
        if (selectedDateMoodLog != null) {
          // If the mood log for the selected date exists, display the mood log
          return _moodLogLayout(selectedDateMoodLog);
        } else {
          // Otherwise, show the mood tracker
          return _moodTrackerLayout(context);
        }
      },
    );
  }

  Widget _moodLogLayout(MoodLogEntity moodLog) {
    final svgPath = 'assets/icons/mood_${moodLog.moodRating}_active.svg';
    final hasComments = moodLog.comment != null ? true : false;
    final tags = [];
    final hasTags = tags.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Mood and Emotions',
            style: textTheme.titleLarge,
          ),
        ),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          // Assuming moodLog.id contains the unique identifier for the mood entry
          final moodId = moodLog.id.toString();
          HapticFeedback.selectionClick();
          // Use GoRouter to navigate to the MoodDetailPage
          GoRouter.of(context).pushNamed(
            RootPath.moodDetail,
            queryParameters: {
              "id": moodId,
            },
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          elevation: 0.5, // Adjusts the elevation for shadow effect
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      svgPath,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mood Entry',
                      style: textTheme.titleMedium,
                    ),
                    const Spacer(), // Pushes the timestamp to the right
                    Text(
                      DateFormat('hh:mm a').format(moodLog.timestamp), // Formats the timestamp to show time only
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                if (hasComments || hasTags) const SizedBox(height: 8),
                if (hasComments)
                  Text(
                    moodLog.comment!,
                    style: const TextStyle(color: Colors.black),
                  ),
                if (hasTags) const SizedBox(height: 16),
                if (hasTags)
                  Wrap(
                    spacing: 8,
                    children: tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.grey[200],
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  void _handleMoodSelected(int moodIndex) {
    setState(() {
      _selectedMoodIndex = moodIndex;
    });
  }

  Widget _moodTrackerLayout(BuildContext context) {
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
                      'How are you feeling?',
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
                                store.dispatch(TriggerSelectMoodAction(_selectedMoodIndex!));
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
                                store.dispatch(TriggerSelectMoodAction(_selectedMoodIndex!));
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
