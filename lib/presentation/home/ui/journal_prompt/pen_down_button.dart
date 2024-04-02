import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teja/shared/common/bento_box.dart';

class PenDownButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double gridWidth; // Added parameter for width
  final double gridHeight; // Added parameter for height

  const PenDownButton({
    Key? key,
    this.text = "Pen Down",
    required this.onTap,
    this.gridWidth = 2, // Default value
    this.gridHeight = 1.5, // Default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).colorScheme.brightness;
    return InkWell(
      onTap: onTap,
      child: BentoBox(
        gridWidth: gridWidth, // Use the parameter
        gridHeight: gridHeight, // Use the parameter
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              'assets/journal/fountain_pen.svg',
              width: 50,
              height: 50,
              colorFilter: ColorFilter.mode(
                brightness == Brightness.light ? Colors.black : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            Text(text!, style: textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
