import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MoodRatingWidget extends StatelessWidget {
  final int moodRating;

  const MoodRatingWidget({
    Key? key,
    required this.moodRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the icon based on the mood rating
    String moodIconPath =
        'assets/icons/mood_${moodRating}_inactive.svg'; // Adjust the path as necessary

    final brightness = Theme.of(context).colorScheme.brightness;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood',
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '$moodRating/5',
              style: textTheme.displaySmall,
            ),
          ],
        ),
        // Replace with SvgPicture.asset if using SVG icons
        SvgPicture.asset(
          moodIconPath,
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(
            brightness == Brightness.light ? Colors.black : Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
