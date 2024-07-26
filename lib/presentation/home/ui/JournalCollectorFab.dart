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

  Widget _buildLabeledIconButton(String label, IconData icon, VoidCallback onPressed) {
    return AnimatedOpacity(
      opacity: isOpened ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
        label: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget mood() {
    return _buildLabeledIconButton('Mood', Icons.mood, () {
      goRouter.pushNamed(RootPath.moodEdit);
    });
  }

  Widget journal() {
    return _buildLabeledIconButton('Journal', Icons.book, () {
      goRouter.pushNamed(RootPath.quickJournalEntry);
    });
  }

  Widget audio() {
    return _buildLabeledIconButton('Audio', Icons.mic, () {
      goRouter.pushNamed(RootPath.journalCategory);
    });
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    goRouter = GoRouter.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
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
