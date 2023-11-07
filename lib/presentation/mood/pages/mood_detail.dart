import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';

class MoodDetailPage extends StatefulWidget {
  final String moodId;

  const MoodDetailPage({
    Key? key,
    required this.moodId,
  }) : super(key: key);

  @override
  _MoodDetailPageState createState() => _MoodDetailPageState();
}

class _MoodDetailPageState extends State<MoodDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the store using 'StoreProvider.of<AppState>(context)'
      Store<AppState> store = StoreProvider.of<AppState>(context);
      // Dispatch the action
      store.dispatch(LoadMoodDetailAction(widget.moodId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MoodDetailState>(
      converter: (store) => store.state.moodDetailPage,
      builder: (_, moodDetailPage) {
        if (moodDetailPage.selectedMoodLog != null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0, // Remove shadow
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                PopupMenuButton<int>(
                  key: const Key("mood_settings"),
                  icon: const Icon(
                    AntDesign.ellipsis1,
                    color: Colors.black,
                    size: 16,
                  ),
                  onSelected: (int result) {
                    if (result == 0) {
                      // Logic for Edit action
                    } else if (result == 1) {
// Logic for Delete action
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
            backgroundColor:
                Colors.white, // Assuming a dark theme from the design
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0), // Adding padding to match design
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: <Widget>[
                  Text(
                    DateFormat(
                            'dd-MMM-yyyy, h:mm a') // Format date as in design
                        .format(moodDetailPage.selectedMoodLog!
                            .timestamp), // Replace with actual date from moodLog if necessary
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 24), // Space between date and title
                  const Text(
                    'mood entry',
                    style: TextStyle(
                      color: Colors.black, // Assuming a light text color
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 48), // Space between title and mood rating
                  const Text(
                    'Mood',
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                  ),
                  const SizedBox(
                      height: 8), // Space between 'Mood' label and rating
                  Text(
                    '${moodDetailPage.selectedMoodLog?.moodRating}/5',
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  // Additional mood details here
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mood Details'),
            ),
            // You might want to style this page as well to keep consistency
          );
        }
      },
    );
  }
}
