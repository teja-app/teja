import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

DateTime now = DateTime.now();
DateTime midnightTomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

class CountdownTimerState extends State<CountdownTimer> {
  Duration duration = midnightTomorrow.difference(now);

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
