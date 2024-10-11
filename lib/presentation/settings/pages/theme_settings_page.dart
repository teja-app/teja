import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/theme/theme_actions.dart';
import 'package:teja/infrastructure/utils/user_preference_helper.dart';
import 'package:teja/theme/theme_service.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({Key? key}) : super(key: key);

  @override
  _ThemeSettingsPageState createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  String _expandedTheme = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchThemeImages();
    });
  }

  Future<void> _fetchThemeImages() async {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(const FetchLightThemeImagesAction());
    store.dispatch(const FetchDarkThemeImagesAction());
    store.dispatch(const FetchSystemThemeImagesAction());
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth > 630 ? 630 : screenWidth;
    final ThemeService themeService =
        Provider.of<ThemeService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: ListView(
            children: [
              _buildThemeSelector('Light Theme', 'DAY', themeService),
              _buildThemeSelector('Dark Theme', 'NIGHT', themeService),
              _buildThemeSelector('System Theme', '', themeService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelector(
      String title, String theme, ThemeService themeService) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        bool isExpanded = _expandedTheme == title;
        bool isSelected = (theme == 'DAY' &&
                themeService.themeMode == ThemeMode.light) ||
            (theme == 'NIGHT' && themeService.themeMode == ThemeMode.dark) ||
            (theme.isEmpty && themeService.themeMode == ThemeMode.system);
        Brightness systemBrightness = MediaQuery.of(context).platformBrightness;

        List<Map<String, dynamic>> images;
        if (theme == 'DAY') {
          images = vm.lightThemeImages;
        } else if (theme == 'NIGHT') {
          images = vm.darkThemeImages;
        } else {
          if (systemBrightness == Brightness.dark) {
            images = vm.darkThemeImages;
          } else {
            images = vm.lightThemeImages;
          }
        }

        return Column(
          children: [
            ListTile(
              title: Text(title),
              leading: Radio<String>(
                value: theme,
                groupValue: themeService.themeMode == ThemeMode.light
                    ? 'DAY'
                    : themeService.themeMode == ThemeMode.dark
                        ? 'NIGHT'
                        : '',
                onChanged: (String? value) {
                  setState(() {
                    themeService.setThemeMode(
                      theme.isEmpty
                          ? ThemeMode.system
                          : (theme == 'DAY' ? ThemeMode.light : ThemeMode.dark),
                    );
                  });
                },
              ),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expandedTheme = isExpanded ? '' : title;
                  });
                },
              ),
              selected: isSelected,
              onTap: () {
                setState(() {
                  themeService.setThemeMode(
                    theme.isEmpty
                        ? ThemeMode.system
                        : (theme == 'DAY' ? ThemeMode.light : ThemeMode.dark),
                  );
                });
              },
            ),
            if (isExpanded) _buildThemeImageGrid(images, theme, vm),
          ],
        );
      },
    );
  }

  Widget _buildThemeImageGrid(
      List<Map<String, dynamic>> imageList, String theme, _ViewModel vm) {
    final ThemeService themeService =
        Provider.of<ThemeService>(context, listen: false);
    final UserPreferenceStorage _preferenceStorage = UserPreferenceStorage();
    if (imageList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No images available for this theme.'),
      );
    }

    final selectedImage = _preferenceStorage.getSelectedImageUrl();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        final image = imageList[index];
        print('Selected Image: $selectedImage');
        print('Image URL: ${image['url']}');
        bool isSelected = image['url'] == selectedImage;

        return GestureDetector(
          onTap: () {
            final currentTheme = themeService.themeMode;
            if ((theme == 'DAY' && currentTheme == ThemeMode.light) ||
                (theme == 'NIGHT' && currentTheme == ThemeMode.dark) ||
                (theme.isEmpty && currentTheme == ThemeMode.system)) {
              StoreProvider.of<AppState>(context).dispatch(
                SelectThemeImageAction(image['url'], image['opacity'] ?? 1.0),
              );
              _preferenceStorage.setSelectedImageUrl(image['url']);
            } else {
              // Optionally show a message or do nothing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select the appropriate theme first')),
              );
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: image['url'],
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              if (isSelected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child:
                      Icon(Icons.check_circle, color: Colors.green, size: 24),
                ),
              if (isSelected)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final List<Map<String, dynamic>> lightThemeImages;
  final List<Map<String, dynamic>> darkThemeImages;
  final List<Map<String, dynamic>> systemThemeImages;
  // final String? selectedImage;

  _ViewModel({
    required this.lightThemeImages,
    required this.darkThemeImages,
    required this.systemThemeImages,
    // this.selectedImage,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final themeState = store.state.themeState;
    return _ViewModel(
      lightThemeImages: themeState.lightThemeImages,
      darkThemeImages: themeState.darkThemeImages,
      systemThemeImages: themeState.systemThemeImages,
      // selectedImage: themeState.selectedImage,
    );
  }
}
