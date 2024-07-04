import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/router.dart';

class JournalCollectorFab extends StatefulWidget {
  const JournalCollectorFab({super.key});

  @override
  JournalCollectorFabState createState() => JournalCollectorFabState();
}

class JournalCollectorFabState extends State<JournalCollectorFab> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  late GoRouter goRouter;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buttonColor = ColorTween(
      begin: Theme.of(context).colorScheme.primary,
      end: Theme.of(context).colorScheme.primary,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        0.75,
        curve: Curves.linear,
      ),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget mood() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          goRouter.pushNamed(RootPath.moodEdit);
        },
        tooltip: 'Mood',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.mood),
      ),
    );
  }

  Widget journal() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          goRouter.pushNamed(RootPath.quickJournalEntry);
        },
        tooltip: 'Journal',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.book),
      ),
    );
  }

  Widget audio() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          goRouter.pushNamed(RootPath.journalCategory);
        },
        tooltip: 'Audio',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.mic),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: isOpened ? AnimatedIcons.menu_close : AnimatedIcons.add_event,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    goRouter = GoRouter.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: mood(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: journal(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: audio(),
        ),
        toggle(),
      ],
    );
  }
}
