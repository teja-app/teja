import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teja/presentation/habits/goal_settings/slider.dart';
import 'package:decimal/decimal.dart';
import 'package:teja/shared/helpers/color.dart';

class GoalSlider extends StatefulWidget {
  final String goalName;
  final double initialValue;
  final int divisions;
  final String? description;

  const GoalSlider({
    Key? key,
    required this.goalName,
    this.description,
    this.initialValue = 0,
    this.divisions = 5,
  }) : super(key: key);

  @override
  _GoalSliderState createState() => _GoalSliderState();
}

class _GoalSliderState extends State<GoalSlider> {
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.goalName, style: textTheme.titleLarge),
        const SizedBox(height: 20),
        Text(widget.description!, style: textTheme.labelLarge),
        const SizedBox(height: 40),
        FillingSlider(
          color: darken(colorScheme.background, 0.1),
          fillColor: colorScheme.surface,
          initialValue: sliderValue * (1 / widget.divisions),
          onChange: (double newValue, double oldValue) {
            var dValue = Decimal.parse(newValue.toString());

            if (dValue % Decimal.parse('0.05') == Decimal.zero) {
              HapticFeedback.lightImpact();
            } else if (dValue % Decimal.parse('0.2') == Decimal.zero) {
              HapticFeedback.heavyImpact();
            }
            setState(() {
              sliderValue = (newValue * widget.divisions).toDouble();
            });
          },
        ),
        Text('${sliderValue.toInt()}/${widget.divisions}'),
      ],
    );
  }
}
