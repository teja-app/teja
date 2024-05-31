import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class RiveAnimationSection extends StatelessWidget {
  final void Function(Artboard) onRiveInit;

  const RiveAnimationSection({Key? key, required this.onRiveInit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleHeightBox(
      gridWidth: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            width: 75, // Set a width for the Rive animation for consistent sizing
            child: RiveAnimation.asset('assets/welcome/safe_icon.riv', onInit: onRiveInit),
          ),
          Expanded(
            child: Text(
              "All your data completely anonymous, decentralized and accessible only to you.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
