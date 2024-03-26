import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/domain/redux/mood/list/state.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Example filter criteria
  List<int> selectedMoodRatings = [];

  void _initializeFilter() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    // Access the current filter state
    final currentFilter = store.state.moodLogListState.filter;
    // Initialize the selectedMoodRatings with the current filter state
    setState(() {
      selectedMoodRatings = List.from(currentFilter.selectedMoodRatings);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeFilter();
  }

  void _applyFilter() {
    final filter = MoodLogFilter(selectedMoodRatings: selectedMoodRatings);
    final store = StoreProvider.of<AppState>(context);

    // Dispatch the action with the new filter object
    store.dispatch(ApplyMoodLogsFilterAction(filter));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final brightness = Theme.of(context).colorScheme.brightness;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Use the theme's background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Select Mood Rating:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Mood rating selection options
          Wrap(
            spacing: 8,
            children: List.generate(5, (index) {
              int moodRating = index + 1;
              return ChoiceChip(
                label: SvgPicture.asset(
                  'assets/icons/mood_${moodRating}_active.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    brightness == Brightness.light ? Colors.black : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                selectedColor: brightness == Brightness.light ? Colors.white : Colors.black,
                backgroundColor: brightness == Brightness.light ? Colors.white : Colors.black,
                selected: selectedMoodRatings.contains(moodRating),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedMoodRatings.add(moodRating);
                    } else {
                      selectedMoodRatings.remove(moodRating);
                    }
                  });
                },
              );
            }),
          ),
          // Add more filter options here
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Apply'),
                onPressed: () {
                  _applyFilter();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
