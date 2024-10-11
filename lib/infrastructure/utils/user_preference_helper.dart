import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:teja/infrastructure/database/hive_collections/user_preference.dart';

class UserPreferenceStorage {
  static const String boxKey = UserPreference.boxKey;

  Future<ThemeMode> getThemeMode() async {
    // final box = await Hive.openBox<UserPreference>(boxKey);
    final box = Hive.box(boxKey);
    final String? theme = box.get('theme_mode', defaultValue: 'system');
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final box = Hive.box(boxKey);
    String themeString = themeMode == ThemeMode.light
        ? 'light'
        : themeMode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await box.put('theme_mode', themeString);
  }

  Future<String?> getSelectedImageUrl() async {
    final box = Hive.box(boxKey);
    return box.get('selected_image_url');
  }

  Future<void> setSelectedImageUrl(String imageUrl) async {
    final box = Hive.box(boxKey);
    await box.put('selected_image_url', imageUrl);
  }

  Future<double> getImageOpacity() async {
    final box = Hive.box(boxKey);
    return box.get('image_opacity', defaultValue: 1.0);
  }

  Future<void> setImageOpacity(double opacity) async {
    final box = Hive.box(boxKey);
    await box.put('image_opacity', opacity);
  }
}
