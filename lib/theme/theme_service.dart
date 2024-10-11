// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ThemeService extends ChangeNotifier {
//   static const String _key = 'theme_mode';
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//   ThemeMode _themeMode = ThemeMode.system;

//   ThemeService() {
//     _loadThemeMode();
//   }

//   ThemeMode get themeMode => _themeMode;

//   Future<void> _loadThemeMode() async {
//     String? theme = await _storage.read(key: _key);
//     switch (theme) {
//       case 'light':
//         _themeMode = ThemeMode.light;
//         break;
//       case 'dark':
//         _themeMode = ThemeMode.dark;
//         break;
//       default:
//         _themeMode = ThemeMode.system;
//     }
//     notifyListeners();
//   }

//   Future<void> setThemeMode(ThemeMode themeMode) async {
//     _themeMode = themeMode;
//     String theme = themeMode == ThemeMode.light
//         ? 'light'
//         : themeMode == ThemeMode.dark
//             ? 'dark'
//             : 'system';
//     await _storage.write(key: _key, value: theme);
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/user_preference_helper.dart';

class ThemeService extends ChangeNotifier {
  final UserPreferenceStorage _preferenceStorage = UserPreferenceStorage();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeService() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadThemeMode() async {
    _themeMode = await _preferenceStorage.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _preferenceStorage.setThemeMode(themeMode);
    notifyListeners();
  }

  Future<void> setSelectedImage(String imageUrl, double opacity) async {
    await _preferenceStorage.setSelectedImageUrl(imageUrl);
    await _preferenceStorage.setImageOpacity(opacity);
    notifyListeners();
  }

  Future<String?> getSelectedImage() async {
    return await _preferenceStorage.getSelectedImageUrl();
  }

  Future<double> getImageOpacity() async {
    return await _preferenceStorage.getImageOpacity();
  }
}
