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
import 'package:teja/theme/padding.dart';

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
            if (_showMoods && moodLogsForSelectedDate != null && moodLogsForSelectedDate.isNotEmpty) ...[
              const SizedBox(height: spacer),
              Text(
                "Mood",
                style: textTheme.titleMedium,
              ),
              _moodLogsLayout(moodLogsForSelectedDate),
            ]
            // Show the mood tracker layout
            // _moodTrackerLayout(context, combinedModel.selectedDate!),
          ],
        );
      },
    );
  }

  Widget _moodLogsLayout(List<MoodLogEntity> moodLogs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: moodLogs.map((moodLog) {
          // Wrap each mood log item with a widget that provides margin or padding if necessary
          return Padding(
            padding: const EdgeInsets.only(right: 8.0), // Adjust spacing as needed
            child: moodLogLayout(moodLog, context),
          );
        }).toList(),
      ),
    );
  }

  void _handleMoodSelected(int moodIndex) {
    setState(() {
      _selectedMoodIndex = moodIndex;
    });
  }
}
