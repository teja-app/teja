// File: lib/features/onboarding/presentation/ui/pages/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:passwordfield/passwordfield.dart'; // Import the passwordfield package
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/onboarding/actions.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpPage({super.key});

  void _showSuccessDialog(
    BuildContext dialogContext,
    Store<AppState> store,
    Function onSuccessClick,
  ) {
    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text(
            'User successfully registered, a verification email has been sent.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                store.dispatch(ClearRegisterMessageAction()); // Clear the registerMessage
                Navigator.of(context).pop(); // Close the dialog
                onSuccessClick();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    final Brightness themeBrightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: FlexibleHeightBox(
            gridWidth: 4,
            child: Column(
              children: [
                // Logo or Header
                SvgPicture.asset(
                  themeBrightness == Brightness.dark ? "assets/logo/White.svg" : "assets/logo/Color.svg",
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Teja',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Teja is a platform aimed at fostering emotional resilience and meaningful relationships. \n \n Our features include Emotional Tracking, Journals, and Guided Meditation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                // Form fields and Sign Up button
                _buildFormColumn(context, navigator),
                // Additional links and information
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'By signing up, you agree to our Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => GoRouter.of(context).push('/sign_in'),
                  child: const Text(
                    'Already have an account? Sign In',
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
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                PasswordField(
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                Button(
                  key: const Key("signUp"),
                  text: 'Sign up',
                  width: 300,
                  onPressed: () {
                    final String name = nameController.text;
                    final String username = usernameController.text;
                    final String email = emailController.text;
                    final String password = passwordController.text;
                    store.dispatch(RegisterAction(username, password, name, email));
                  },
                  buttonType: ButtonType.primary,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     final String name = nameController.text;
                //     final String username = usernameController.text;
                //     final String email = emailController.text;
                //     final String password = passwordController.text;
                //     store.dispatch(
                //         RegisterAction(username, password, name, email));
                //   },
                //   child: Text('Sign Up'),
                // ),
                _buildMessageWidget(store, context, navigator),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageWidget(Store<AppState> store, BuildContext context, NavigatorState navigator) {
    final message = store.state.authState.registerMessage;
    if (message.isNotEmpty) {
      if (message.contains('successfully')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSuccessDialog(context, store, () => navigator.pop());
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          store.dispatch(ClearRegisterMessageAction());
        });
      }
    }
    return Container(); // Return an empty container as the builder must return a widget
  }
}
