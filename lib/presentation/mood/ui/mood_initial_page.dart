import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/mood_editor_actions.dart';

// This is the standalone MoodIconsLayout widget.
class MoodInitialPage extends StatefulWidget {
  final Function(int)? onMoodSelected;
  final PageController controller; // Add this line

  const MoodInitialPage(
      {Key? key, this.onMoodSelected, required this.controller})
      : super(key: key); // Modify this line

  @override
  _MoodInitialPageState createState() => _MoodInitialPageState();
}

class _MoodInitialPageState extends State<MoodInitialPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 1; i <= 5; i++)
                _buildMoodIcon('assets/icons/mood_${i}_inactive.svg', i),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(String svgPath, int moodIndex) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return GestureDetector(
            onTap: () {
              store.dispatch(SelectMoodAction(moodIndex));
              store.dispatch(const ChangePageAction(
                1,
              ));
            },
            child: Opacity(
              opacity: (store.state.moodEditorState.currentMoodLog
                              ?.moodRating ==
                          null ||
                      store.state.moodEditorState.currentMoodLog?.moodRating ==
                          moodIndex)
                  ? 1.0
                  : 0.5, // Set transparency
              child: SvgPicture.asset(
                svgPath,
                width: 40,
                height: 40,
              ),
            ),
          );
        });
  }
}
