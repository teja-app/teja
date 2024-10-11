import 'package:flutter/foundation.dart';

@immutable
class FetchLightThemeImagesAction {
  const FetchLightThemeImagesAction();
}

@immutable
class FetchDarkThemeImagesAction {
  const FetchDarkThemeImagesAction();
}

@immutable
class FetchSystemThemeImagesAction {
  const FetchSystemThemeImagesAction();
}

@immutable
class ThemeImagesReceivedAction {
  final List<Map<String, dynamic>> images;
  final String themeType; // 'light', 'dark', or 'system'

  const ThemeImagesReceivedAction(this.images, this.themeType);
}

@immutable
class ThemeImagesFailedAction {
  final String error;

  const ThemeImagesFailedAction(this.error);
}

@immutable
class SelectThemeImageAction {
  final String imageUrl;
  final double opacity;

  const SelectThemeImageAction(this.imageUrl, this.opacity);
}
