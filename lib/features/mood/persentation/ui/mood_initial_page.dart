import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                _buildMoodIcon('assets/icons/mood_${i}_inactive.svg', i),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(String svgPath, int moodIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMoodIndex = moodIndex; // Set the selected mood on tap
        });
        if (widget.onMoodSelected != null) {
          widget.onMoodSelected!(moodIndex); // If there's a callback, call it
        }
        // Navigate to the second page without showing continue or skip buttons
        widget.controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Opacity(
        opacity: (_selectedMoodIndex == null || _selectedMoodIndex == moodIndex)
            ? 1.0
            : 0.5, // Set transparency
        child: SvgPicture.asset(
          svgPath,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
