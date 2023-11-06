import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:swayam/presentation/onboarding/widgets/slide_item_widget.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  List<Slide> slides = [
    Slide(
      title: "Embark on a journey to clarity.",
      image: "assets/welcome/DiscoverClarity.jpeg",
    ),
    Slide(
      title: "Unveil the power of expression.",
      image: "assets/welcome/EmbraceExpression.jpeg",
    ),
    Slide(
      title: "Unwind in a haven of calm.",
      image: "assets/welcome/CultivateCalm.jpeg",
    ),
    Slide(
      title: "Nurture meaningful connections.",
      image: "assets/welcome/CultivateConnections.jpeg",
    ),
  ];

  final PageController _pageController = PageController();
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      final currentPage = (_pageController.page ?? 0).round();
      if (currentPage == slides.length - 1) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pageController.addListener(() {
      if (_pageController.position.userScrollDirection ==
          ScrollDirection.idle) {
        if (!_timer.isActive) {
          // Wait for 10 seconds before restarting the auto-slide
          Future.delayed(const Duration(seconds: 10), () {
            // Only restart the timer if the user hasn't started scrolling again
            if (_pageController.position.userScrollDirection ==
                ScrollDirection.idle) {
              _startTimer();
            }
          });
        }
      } else {
        // Cancel the timer if the user is scrolling
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer
    _pageController.dispose(); // Dispose the page controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: slides.length,
      itemBuilder: (context, index) {
        return SlideItemWidget(slide: slides[index]);
      },
    );
  }
}
