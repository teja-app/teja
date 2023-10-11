// File: lib/features/onboarding/presentation/ui/pages/sign_in_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:passwordfield/passwordfield.dart'; // Import the passwordfield package
import 'package:redux/redux.dart';
import 'package:swayam/features/onboarding/data/redux/actions.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:swayam/shared/redux/state/app_state.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID on Android
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? iosInfo.model;
    }
    // Default value if neither Android nor iOS
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Logo or Header
                Image.asset(
                  'assets/logo/AppIcon.png',
                  fit: BoxFit.cover,
                  height: 60,
                ),
                // Form fields and Sign In button
                _buildFormColumn(context, navigator),
                // Additional links and information
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => GoRouter.of(context).push('/sign_up'),
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormColumn(BuildContext context, NavigatorState navigator) {
    return Center(
      child: SizedBox(
        width: 400, // Set the maximum width for the form
        child: StoreConnector<AppState, Store<AppState>>(
          converter: (store) => store,
          builder: (context, store) {
            return Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                PasswordField(
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                Button(
                  key: const Key("signIn"),
                  text: 'Sign In',
                  width: 300,
                  onPressed: () async {
                    final String username = usernameController.text;
                    final String password = passwordController.text;
                    final deviceId = await getDeviceId();
                    store.dispatch(SignInAction(username, password, deviceId));
                  },
                  buttonType: ButtonType.primary,
                ),
                _buildMessageWidget(store, context, navigator),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageWidget(
    Store<AppState> store,
    BuildContext context,
    NavigatorState navigator,
  ) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        final message = store.state.authState.signInMessage;
        if (message.isNotEmpty) {
          if (message.contains('successfully')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigator.pop(); // Assuming you want to pop the page on success
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message), // Show error message in a snackbar
                ),
              );
              store.dispatch(
                  ClearSignInMessageAction()); // Assuming you have a ClearSignInMessageAction
            });
          }
        }
        return Container(); // Return an empty container as the builder must return a widget
      },
    );
  }
}
