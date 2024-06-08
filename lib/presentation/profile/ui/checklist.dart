import 'package:flutter/material.dart';
import 'package:teja/presentation/profile/ui/data_check_overlay.dart';

class Checklist extends StatelessWidget {
  final List<Map<String, bool>> checklist;
  final Widget child;

  const Checklist({
    Key? key,
    required this.checklist,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (checklist.any((item) => item.containsValue(false)))
          Positioned.fill(
            child: DataCheckOverlay(checklist: checklist),
          ),
      ],
    );
  }
}
