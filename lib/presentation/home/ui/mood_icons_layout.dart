import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/mood_editor_reducer.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';

// This is the standalone MoodIconsLayout widget.
class MoodIconsLayout extends StatefulWidget {
  final Function(int)? onMoodSelected;

  const MoodIconsLayout({Key? key, this.onMoodSelected}) : super(key: key);

  @override
  _MoodIconsLayoutState createState() => _MoodIconsLayoutState();
}

class _MoodIconsLayoutState extends State<MoodIconsLayout> {
  int? _selectedMoodIndex;

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
                _buildMoodIcon(
                    'assets/icons/mood_${i}_${_getMoodStatus(i)}.svg', i),
            ],
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
                    GoRouter.of(context).push('/mood');
                  },
                ),
                Button(
                  text: "Done",
                  icon: AntDesign.check,
                  buttonType: ButtonType.secondary,
                  onPressed: () {
                    // Define action for skip
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Return 'active' if the mood is selected, otherwise 'inactive'
  String _getMoodStatus(int moodIndex) {
    return (_selectedMoodIndex == moodIndex) ? 'active' : 'inactive';
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
              setState(() {
                _selectedMoodIndex = moodIndex; // Set the selected mood on tap
              });
            },
            child: Opacity(
              opacity: (_selectedMoodIndex == null ||
                      _selectedMoodIndex == moodIndex)
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
