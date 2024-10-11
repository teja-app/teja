import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BackgroundImageWrapper extends StatefulWidget {
  final Widget child;
  final ThemeMode themeMode;
  final String? backgroundImageUrl;

  const BackgroundImageWrapper({
    Key? key,
    required this.child,
    required this.themeMode,
    this.backgroundImageUrl,
  }) : super(key: key);

  @override
  _BackgroundImageWrapperState createState() => _BackgroundImageWrapperState();
}

class _BackgroundImageWrapperState extends State<BackgroundImageWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.themeMode == ThemeMode.system ||
        widget.backgroundImageUrl == null ||
        widget.backgroundImageUrl!.isEmpty) {
      return widget.child;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Opacity(
              opacity: 1,
              child: CachedNetworkImage(
                imageUrl: widget.backgroundImageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ),
        _buildOverlay(context, widget.themeMode),
        widget.child,
      ],
    );
  }

  Widget _buildOverlay(BuildContext context, ThemeMode themeMode) {
    final isDarkMode = themeMode == ThemeMode.dark;
    return Positioned.fill(
      child: Container(
        color: isDarkMode
            ? Colors.black.withOpacity(0.7)
            : Colors.white.withOpacity(0.7),
      ),
    );
  }
}
