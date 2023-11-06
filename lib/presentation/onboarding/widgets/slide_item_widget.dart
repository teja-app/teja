import 'package:flutter/material.dart';
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.image,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.grey[200],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    slide.title,
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
