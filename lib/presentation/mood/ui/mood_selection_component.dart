import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodSelectionComponent extends StatefulWidget {
  final int? initialMood;
  final Function(int) onMoodSelected;

  const MoodSelectionComponent({
    Key? key,
    this.initialMood,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  MoodSelectionComponentState createState() => MoodSelectionComponentState();
}

class MoodSelectionComponentState extends State<MoodSelectionComponent> {
  int? _selectedMoodIndex;

  @override
  void initState() {
    super.initState();
    // Initialize the selected mood if provided
    _selectedMoodIndex = widget.initialMood;
  }

  @override
  void didUpdateWidget(MoodSelectionComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMood != oldWidget.initialMood) {
      setState(() {
        _selectedMoodIndex = widget.initialMood;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (index) => _buildMoodIcon(index + 1)),
    );
  }

  Widget _buildMoodIcon(int moodIndex) {
    String svgPath = 'assets/icons/mood_${moodIndex}_${_getMoodStatus(moodIndex)}.svg';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMoodIndex = moodIndex;
          widget.onMoodSelected(moodIndex);
        });
      },
      child: SvgPicture.asset(
        svgPath,
        width: 40,
        height: 40,
      ),
    );
  }

  String _getMoodStatus(int moodIndex) {
    return (_selectedMoodIndex == moodIndex) ? 'active' : 'inactive';
  }
}
