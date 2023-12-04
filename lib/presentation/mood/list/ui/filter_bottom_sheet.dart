import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
    print("_initializeFilter:selectedMoodRatings: ${currentFilter.selectedMoodRatings}");
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
    return Container(
      padding: const EdgeInsets.all(16),
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
                label: Text(moodRating.toString()),
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
