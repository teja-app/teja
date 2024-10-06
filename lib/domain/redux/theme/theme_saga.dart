import 'package:dio/dio.dart';
import 'package:redux_saga/redux_saga.dart';
import 'theme_actions.dart';
import 'package:teja/infrastructure/api/theme_api.dart';

class ThemeSaga {
  final ThemeApi _themeApi = ThemeApi();

  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchLightThemeImages,
        pattern: FetchLightThemeImagesAction);
    yield TakeLatest(_fetchDarkThemeImages,
        pattern: FetchDarkThemeImagesAction);
  }

  Iterable<void> _fetchLightThemeImages({dynamic action}) sync* {
    yield* _fetchThemeImages('DAY', 'light');
  }

  Iterable<void> _fetchDarkThemeImages({dynamic action}) sync* {
    yield* _fetchThemeImages('NIGHT', 'dark');
  }

  Iterable<void> _fetchThemeImages(String theme, String themeType) sync* {
    print('Fetching $themeType theme images');
    final response = Result<Response>();
    yield Call(_themeApi.fetchThemeData, args: [theme], result: response);
    print('Response for $themeType theme: ${response.value?.data}');

    if (response.value?.statusCode == 200) {
      final data = response.value?.data;
      if (data is List) {
        try {
          final List<Map<String, dynamic>> images = data.map((item) {
            if (item is Map<String, dynamic>) {
              return item;
            } else {
              throw FormatException('Invalid item format');
            }
          }).toList();
          yield Put(ThemeImagesReceivedAction(images, themeType));
        } catch (e) {
          print('Error parsing $themeType theme images: $e');
          yield Put(ThemeImagesFailedAction(
              'Error parsing $themeType theme images: $e'));
        }
      } else {
        yield Put(ThemeImagesFailedAction(
            'Invalid $themeType theme images data format'));
      }
    } else {
      yield Put(
          ThemeImagesFailedAction('Failed to fetch $themeType theme images'));
    }
  }
}
