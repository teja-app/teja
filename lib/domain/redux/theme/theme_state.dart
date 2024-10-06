import 'package:flutter/foundation.dart';

@immutable
class ThemeState {
  final List<Map<String, dynamic>> lightThemeImages;
  final List<Map<String, dynamic>> darkThemeImages;
  final List<Map<String, dynamic>> systemThemeImages;
  final String? selectedImage;
  final double? selectedOpacity;
  final String? errorMessage;

  const ThemeState({
    this.lightThemeImages = const [],
    this.darkThemeImages = const [],
    this.systemThemeImages = const [],
    this.selectedImage,
    this.selectedOpacity,
    this.errorMessage,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      lightThemeImages: [],
      darkThemeImages: [],
      systemThemeImages: [],
      selectedImage: null,
      selectedOpacity: null,
      errorMessage: null,
    );
  }

  ThemeState copyWith({
    List<Map<String, dynamic>>? lightThemeImages,
    List<Map<String, dynamic>>? darkThemeImages,
    List<Map<String, dynamic>>? systemThemeImages,
    String? selectedImage,
    double? selectedOpacity,
    String? errorMessage,
  }) {
    return ThemeState(
      lightThemeImages: lightThemeImages ?? this.lightThemeImages,
      darkThemeImages: darkThemeImages ?? this.darkThemeImages,
      systemThemeImages: systemThemeImages ?? this.systemThemeImages,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedOpacity: selectedOpacity ?? this.selectedOpacity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
