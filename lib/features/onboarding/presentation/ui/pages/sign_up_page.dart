// File: lib/features/onboarding/presentation/ui/pages/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:passwordfield/passwordfield.dart'; // Import the passwordfield package
import 'package:redux/redux.dart';
import 'package:swayam/features/onboarding/data/redux/actions.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/redux/state/app_state.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showSuccessDialog(
    BuildContext dialogContext,
    Store<AppState> store,
    Function onSuccessClick,
  ) {
    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text(
            'User successfully registered, a verification email has been sent.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                store.dispatch(
                    ClearRegisterMessageAction()); // Clear the registerMessage
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap your Column with SingleChildScrollView
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              PasswordField(
                // Use the PasswordField widget instead of TextField
                controller: passwordController,
                // You can customize the appearance using various properties
                // available on the PasswordField widget
              ),
              SizedBox(height: 20),
              StoreConnector<AppState, Store<AppState>>(
                converter: (store) => store,
                builder: (context, store) {
                  return ElevatedButton(
                    onPressed: () {
                      final String name = nameController.text;
                      final String username = usernameController.text;
                      final String email = emailController.text;
                      final String password = passwordController.text;
                      store.dispatch(
                          RegisterAction(username, password, name, email));
                    },
                    child: Text('Sign Up'),
                  );
                },
              ),
              StoreConnector<AppState, Store<AppState>>(
                converter: (store) => store,
                builder: (context, store) {
                  final message = store.state.authState.registerMessage;
                  print("message ${message}");
                  if (message.isNotEmpty) {
                    if (message.contains('successfully')) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showSuccessDialog(
                            context, store, () => navigator.pop());
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                message), // Show error message in a snackbar
                          ),
                        );
                        store.dispatch(
                            ClearRegisterMessageAction()); // Clear the registerMessage
                      });
                    }
                  }
                  return Container(); // Return an empty container as the builder must return a widget
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
