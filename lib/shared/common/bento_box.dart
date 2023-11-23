import 'package:flutter/material.dart';

class BentoBox extends StatelessWidget {
  final double gridWidth;
  final double gridHeight;
  final double? tabletGridWidth;
  final double? desktopGridWidth;
  final double? tabletGridHeight;
  final double? desktopGridHeight;
  final double margin;
  final double padding;
  final Widget child;
  final Color? color;
  final int desktopColumns;
  final int tabletColumns;
  final int mobileColumns;

  const BentoBox(
      {Key? key,
      required this.gridWidth,
      required this.gridHeight,
      required this.child,
      this.tabletGridWidth,
      this.desktopGridWidth,
      this.tabletGridHeight,
      this.desktopGridHeight,
      this.color,
      this.margin = 8.0,
      this.padding = 16.0,
      this.desktopColumns = 12,
      this.tabletColumns = 8,
      this.mobileColumns = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth > 600 && screenWidth <= 1200;
    final bool isDesktop = screenWidth > 1200;

    int columns = mobileColumns;
    if (isDesktop) {
      columns = desktopColumns;
    } else if (isTablet) {
      columns = tabletColumns;
    }

    double effectiveGridWidth = gridWidth;
    if (isDesktop) {
      effectiveGridWidth = desktopGridWidth ?? gridWidth;
    } else if (isTablet) {
      effectiveGridWidth = tabletGridWidth ?? gridWidth;
    }

    double effectiveGridHeight = gridHeight;
    if (isDesktop) {
      effectiveGridHeight = desktopGridHeight ?? gridHeight;
    }
    if (isTablet) {
      effectiveGridHeight = tabletGridHeight ?? gridHeight;
    }

    final double baseGridColumnWidth =
        (screenWidth - ((columns + 1) * margin)) / columns;
    final double containerWidth = baseGridColumnWidth * effectiveGridWidth +
        margin * (effectiveGridWidth - 1);
    final double containerHeight = baseGridColumnWidth * effectiveGridHeight +
        margin * (effectiveGridHeight - 1);

    return Container(
      width: containerWidth,
      height: containerHeight,
      margin: EdgeInsets.all(margin / 2),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ?? cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: (color ?? cardTheme.color)!.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
