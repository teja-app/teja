import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  Duration duration = const Duration(hours: 2, minutes: 24, seconds: 54);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (duration.inSeconds <= 0) {
          timer.cancel();
        } else {
          duration -= const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/background/thunder.png',
          width: 200,
        ),
        Text(
          "Page will be ready in",
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge,
        ),
        Text(
          "$hours:$minutes:$seconds",
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
