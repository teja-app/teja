import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/helpers/logger.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/shared/storage/secure_storage.dart';
import 'package:swayam/theme/dark_theme.dart';
import 'package:swayam/theme/light_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final accessToken = await readSecureData('access_token');
      if (accessToken != null && accessToken.isNotEmpty) {
        try {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
          int expiration = decodedToken['exp'];
          // Redirect if the access token has expired.
          if (currentTime < expiration) {
            router.goNamed(RootPath.home);
          } else {
            logger.i('Access token has expired, redirecting to sign-in page.');
            // Add navigation to sign-in page here if needed
          }
        } catch (e) {
          logger.e('Error decoding token: $e');
          // Handle decoding error or invalid token here
        }
      } else {
        logger.i('No access token found, redirecting to sign-in page.');
        // Add navigation to sign-in page here if needed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthState>(
      converter: (store) => store.state.authState,
      builder: (context, authState) {
        return MaterialApp.router(
          title: 'Swayam',
          debugShowCheckedModeBanner: false,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          theme: lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
