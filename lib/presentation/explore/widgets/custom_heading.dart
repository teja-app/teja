import 'package:flutter/material.dart';

class CustomHeading extends StatelessWidget {
  const CustomHeading({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.color,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge,
        ),
        SizedBox(height: 10.0),
        Text(
          subTitle,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}
