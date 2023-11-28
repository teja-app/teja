import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

const defaultGraphColors = [
  Colors.limeAccent,
  Colors.blue,
  Colors.red,
  Colors.orange,
];

class GoalChart extends StatefulWidget {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;

  const GoalChart({
    Key? key,
    required this.ticks,
    required this.features,
    required this.data,
    this.reverseAxis = false,
    this.ticksTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
    this.featuresTextStyle = const TextStyle(color: Colors.black, fontSize: 10),
    this.outlineColor = Colors.black,
    this.axisColor = Colors.grey,
    this.graphColors = defaultGraphColors,
    this.sides = 0,
  }) : super(key: key);

  factory GoalChart.light({
    required List<int> ticks,
    required List<String> features,
    required List<List<num>> data,
    bool reverseAxis = false,
    bool useSides = false,
    graphColors = defaultGraphColors,
  }) {
    return GoalChart(
        ticks: ticks,
        features: features,
        data: data,
        reverseAxis: reverseAxis,
        graphColors: graphColors,
        sides: useSides ? features.length : 0);
  }

  factory GoalChart.dark({
    required List<int> ticks,
    required List<String> features,
    required List<List<num>> data,
    bool reverseAxis = false,
    bool useSides = false,
    graphColors = defaultGraphColors,
  }) {
    return GoalChart(
        ticks: ticks,
        features: features,
        data: data,
        featuresTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
        outlineColor: Colors.white,
        graphColors: graphColors,
        axisColor: Colors.grey,
        reverseAxis: reverseAxis,
        sides: useSides ? features.length : 0);
  }

  @override
  _GoalChartState createState() => _GoalChartState();
}

class _GoalChartState extends State<GoalChart>
    with SingleTickerProviderStateMixin {
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    ))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    animationController.forward();
  }

  @override
  void didUpdateWidget(GoalChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(
        double.infinity,
        double.infinity,
      ),
      painter: RadarChartPainter(
        widget.ticks,
        widget.features,
        widget.data,
        widget.reverseAxis,
        widget.ticksTextStyle,
        widget.featuresTextStyle,
        widget.outlineColor,
        widget.axisColor,
        widget.graphColors,
        widget.sides,
        this.fraction,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class RadarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final double fraction;

  RadarChartPainter(
    this.ticks,
    this.features,
    this.data,
    this.reverseAxis,
    this.ticksTextStyle,
    this.featuresTextStyle,
    this.outlineColor,
    this.axisColor,
    this.graphColors,
    this.sides,
    this.fraction,
  );

  Path variablePath(Size size, double radius, int sides) {
    var path = Path();
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    if (sides < 3) {
      // Draw a circle
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));
    } else {
      // Draw a polygon
      Offset startPoint = Offset(radius * cos(-pi / 2), radius * sin(-pi / 2));

      path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

      for (int i = 1; i <= sides; i++) {
        double x = radius * cos(angle * i - pi / 2) + center.dx;
        double y = radius * sin(angle * i - pi / 2) + center.dy;
        path.lineTo(x, y);
      }
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the center and radius as before
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = math.min(centerX, centerY) * 0.8;
    final scale = radius / ticks.last;

    // Painting the chart outline
    var outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    var ticksPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    // canvas.drawPath(variablePath(size, radius, this.sides), outlinePaint);
    // Painting the circles and labels for the given ticks (could be auto-generated)
    // The last tick is ignored, since it overlaps with the feature label
    var tickDistance = radius / (ticks.length);
    var tickLabels = reverseAxis ? ticks.reversed.toList() : ticks;

    // if (reverseAxis) {
    //   TextPainter(
    //     text: TextSpan(text: tickLabels[0].toString(), style: ticksTextStyle),
    //     textDirection: TextDirection.ltr,
    //   )
    //     ..layout(minWidth: 0, maxWidth: size.width)
    //     ..paint(canvas, Offset(centerX, centerY - ticksTextStyle.fontSize!));
    // }

    tickLabels
        .sublist(
            reverseAxis ? 1 : 0, reverseAxis ? ticks.length : ticks.length - 1)
        .asMap()
        .forEach((index, tick) {
      var tickRadius = tickDistance * (index);

      canvas.drawPath(variablePath(size, tickRadius, this.sides), ticksPaint);
    });

    // Painting the axis for each given feature with adjusted text
    var angle = (2 * pi) / features.length;

    features.asMap().forEach((index, feature) {
      var featureAngle = angle * index - pi / 2;
      var xAngle = cos(featureAngle);
      var yAngle = sin(featureAngle);

      // Adjust the radius for text based on the angle to avoid crowding on the sides
      var adjustedRadiusForText = radius; // Base offset for text
      // Increase the radius offset for text on the sides
      if (xAngle.abs() > yAngle.abs()) {
        adjustedRadiusForText *= 1.2; // Adjust this factor as needed
      }

      var featureOffset = Offset(
        centerX + adjustedRadiusForText * xAngle,
        centerY + adjustedRadiusForText * yAngle,
      );

      // Calculate the text painter for the feature text
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: feature, style: featuresTextStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      // Layout the text
      textPainter.layout();

      // Calculate the position to draw the text so it's centered on the feature line
      Offset textPosition = Offset(
        featureOffset.dx - textPainter.width / 2,
        featureOffset.dy - textPainter.height / 2,
      );

      // Paint the text
      textPainter.paint(canvas, textPosition);
    });

    // Painting each graph with curves
    data.asMap().forEach((graphIndex, graph) {
      var path = Path();
      List<Offset> points = List.generate(graph.length, (index) {
        final angle = (2 * pi * index / features.length) - (pi / 2);
        final x = centerX + scale * graph[index] * cos(angle);
        final y = centerY + scale * graph[index] * sin(angle);
        return Offset(x, y);
      });

      // Start the path
      path.moveTo(points[0].dx, points[0].dy);

      // Draw the curves
      for (int i = 0; i < points.length; i++) {
        final currentPoint = points[i];
        final nextPoint = points[(i + 1) % points.length];
        final controlPoint1 = (currentPoint + nextPoint) / 2;
        final controlPoint2 = controlPoint1;

        path.quadraticBezierTo(
          controlPoint1.dx,
          controlPoint2.dy,
          nextPoint.dx,
          nextPoint.dy,
        );
      }

      path.close();

      // Use the paints as before to draw the filled graph and the outline
      var graphPaint = Paint()
        ..color = graphColors[graphIndex % graphColors.length].withOpacity(0.5)
        ..style = PaintingStyle.fill;

      var graphOutlinePaint = Paint()
        ..color = graphColors[graphIndex % graphColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    });
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
