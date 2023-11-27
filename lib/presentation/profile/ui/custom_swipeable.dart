import 'package:flutter/material.dart';

class CustomSwipeable extends StatefulWidget {
  final Widget child;
  final double threshold;
  final Color progressColor;

  const CustomSwipeable({
    Key? key,
    required this.child,
    this.threshold = 100.0,
    this.progressColor = Colors.blue, // Default progress color
  }) : super(key: key);

  @override
  _CustomSwipeableState createState() => _CustomSwipeableState();
}

class _CustomSwipeableState extends State<CustomSwipeable>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  double dragExtent = 0.0;
  late Animation<double> _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      value: 0, // start at 0
    );

    _colorTween =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragExtent += details.primaryDelta!;
      _animationController.value =
          (dragExtent / widget.threshold).clamp(0.0, 1.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_animationController.value == 1.0) {
      // Perform your action here, like revealing more options
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Swiped!'),
            content: Text('You swiped past the threshold!'),
          );
        },
      );
    } else {
      // Swipe was cancelled
      _animationController.reverse();
    }
    setState(() {
      dragExtent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          // Progress bar background
          Container(
            color: widget.progressColor.withOpacity(_colorTween.value),
            width: double.infinity,
            height: double.infinity,
          ),
          // Foreground child widget
          widget.child,
        ],
      ),
    );
  }
}
