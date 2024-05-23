import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/auth/auth_action.dart';
import 'package:teja/domain/redux/auth/auth_state.dart';
import 'package:teja/shared/common/button.dart';

class RecoverAccountScreen extends StatefulWidget {
  @override
  _RecoverAccountScreenState createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  final TextEditingController _mnemonicController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _mnemonicController.dispose();
    super.dispose();
  }

  void _authenticate() {
    final mnemonic = _mnemonicController.text.trim();
    if (mnemonic.isNotEmpty) {
      StoreProvider.of<AppState>(context).dispatch(AuthenticateAction(mnemonic));
    } else {
      setState(() {
        _errorMessage = 'Please enter your recovery phrase.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recover Account'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Exit the recovery screen
          },
        ),
      ),
      body: StoreConnector<AppState, AuthState>(
        converter: (Store<AppState> store) => store.state.authState,
        builder: (context, authState) {
          if (authState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authState.isAuthSuccessful) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context); // Close the recovery screen on successful authentication
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your recovery phrase to authenticate',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _mnemonicController,
                  decoration: InputDecoration(
                    labelText: 'Recovery Phrase',
                    errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Button(
                    onPressed: _authenticate,
                    text: 'Authenticate',
                    buttonType: ButtonType.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
