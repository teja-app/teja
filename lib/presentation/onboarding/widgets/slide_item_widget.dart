import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Slide {
  final String title;
  final String image;

  Slide({
    required this.title,
    required this.image,
  })  : assert(title.isNotEmpty, 'Title cannot be empty'),
        assert(image.isNotEmpty, 'Image path cannot be empty');
}

class SlideItemWidget extends StatelessWidget {
  final Slide slide;

  const SlideItemWidget({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).colorScheme.brightness;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            slide.image,
            colorFilter: ColorFilter.mode(
                brightness == Brightness.light ? Colors.black : Colors.white,
                BlendMode.srcIn),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20), // Space between image and text
          DefaultTextStyle(
            style: textTheme.titleLarge!,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  slide.title,
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 70),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ),
        ],
      ),
    );
  }
}
