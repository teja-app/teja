import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/helpers/logger.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Log when the App widget is built
    logger.i('App widget is being built.');

    return StoreConnector<AppState, AuthState>(
      converter: (store) => store.state.authState,
      onInitialBuild: (authState) async {
        int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final accessToken = await readSecureData('access_token');
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
        int expiration = decodedToken['exp'];
        // Redirect if the access token has expired.
        if (currentTime < expiration) {
          router.goNamed(RootPath.home);
        } else {
          logger.i('Access token has expired, redirecting to sign-in page.');
        }
      },
      builder: (context, authState) {
        final textTheme = Theme.of(context).textTheme;

        return MaterialApp.router(
          title: 'Swayam',
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            cardColor: Colors.black,
            cardTheme: CardTheme(color: Colors.grey.shade800),
            popupMenuTheme: PopupMenuThemeData(
              color: Colors.grey.shade800, // Dark theme popup menu color
            ),
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              // seedColor: Colors.white,
              seedColor: Colors.white, // Adjust seed color for dark theme
              primary: Colors.lightBlueAccent,
              secondary: Colors.grey,
              surface: Colors.grey.shade700,
              background: Colors.grey.shade900,
            ),
            scaffoldBackgroundColor: Colors.grey.shade900,
            appBarTheme: AppBarTheme(
              // backgroundColor: Colors.grey.shade900,
              color: Colors.grey.shade900,
            ),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          theme: ThemeData(
            textTheme: GoogleFonts.ubuntuTextTheme(textTheme).copyWith(
              bodyMedium: GoogleFonts.wixMadeforText(
                textStyle: textTheme.bodyMedium,
              ),
            ),
            cardColor: Colors.white,
            cardTheme: const CardTheme(color: Colors.white),
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white, // Set your desired color here
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              primary: Colors.lightBlueAccent,
              secondary: Colors.black,
              surface: Colors.black,
              background: Colors.grey.shade100,
            ),
            scaffoldBackgroundColor: Colors.grey.shade100,
            appBarTheme: AppBarTheme(
              // backgroundColor: Colors.grey.shade100,
              color: Colors.grey.shade100,
            ),
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
