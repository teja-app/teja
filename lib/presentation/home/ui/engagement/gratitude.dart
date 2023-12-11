import 'package:flutter/material.dart';
// import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class GratitudeCard extends StatelessWidget {
  const GratitudeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FlexibleHeightBox(
      gridWidth: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "I am grateful for the beauty of the nature that’s all around me.",
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
