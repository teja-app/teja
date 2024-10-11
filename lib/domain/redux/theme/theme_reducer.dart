import 'package:redux/redux.dart';
import 'theme_actions.dart';
import 'theme_state.dart';

Reducer<ThemeState> themeReducer = combineReducers<ThemeState>([
  TypedReducer<ThemeState, ThemeImagesReceivedAction>(_themeImagesReceived),
  TypedReducer<ThemeState, ThemeImagesFailedAction>(_themeImagesFailed),
  // TypedReducer<ThemeState, SelectThemeImageAction>(_selectThemeImage),
]);

ThemeState _themeImagesReceived(
    ThemeState state, ThemeImagesReceivedAction action) {
  switch (action.themeType) {
    case 'light':
      return state.copyWith(lightThemeImages: action.images);
    case 'dark':
      return state.copyWith(darkThemeImages: action.images);
    case 'system':
      return state.copyWith(systemThemeImages: action.images);
    default:
      return state;
  }
}

ThemeState _themeImagesFailed(
    ThemeState state, ThemeImagesFailedAction action) {
  return state.copyWith(errorMessage: action.error);
}

// ThemeState _selectThemeImage(ThemeState state, SelectThemeImageAction action) {
//   return state.copyWith(
//     selectedImage: action.imageUrl,
//     selectedOpacity: action.opacity,
//   );
// }
