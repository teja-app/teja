import 'package:flutter/material.dart';
import 'package:teja/presentation/home/ui/count_down_timer.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Countdown Timer Starting from 1 Hour',
  type: CountdownTimer,
)
Widget buildCountdownTimer1HourUseCase(BuildContext context) {
  return CountdownTimer(
    key: Key('1-hour-timer'),
  );
}
