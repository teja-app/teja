import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/mood_editor_actions.dart';
import 'package:swayam/presentation/home/ui/mood_icons_layout.dart';
import 'package:swayam/shared/common/button.dart';

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
      // Dispatch the action after the frame is rendered
      // to avoid any build method side-effects
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      store.dispatch(GetTodayMoodAction());
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Dispatch the action after the frame is rendered
      // to avoid any build method side-effects
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      store.dispatch(GetTodayMoodAction());
    });
    _showMoods = false;
    _selectedMoodIndex = null;
  }

  @override
  Widget build(BuildContext context) {
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
                ? MoodIconsLayout(
                    onMoodSelected: (int moodIndex) {
                      setState(() {
                        _selectedMoodIndex = moodIndex;
                      });
                    },
                  )
                : _initialLayout(),
          ),
        ],
      ),
    );
  }

  Widget _initialLayout() {
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
                const Text('Mood and Emotions',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) =>
                        const Icon(Icons.check, color: Colors.black, size: 20),
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
              const Text('Track Mood',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 12),
              const Text('How do you feel today?',
                  style: TextStyle(color: Colors.black)),
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
