import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/auth/auth_action.dart';
import 'package:teja/domain/redux/auth/auth_state.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:teja/shared/storage/secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  String _mnemonic = '';
  String _confirmedMnemonic = '';
  bool _isConfirmed = false;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  TextEditingController _textController = TextEditingController();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMnemonic();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _currentPageNotifier.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    _currentPageNotifier.value = _pageController.page?.round() ?? 0;
  }

  void _fetchMnemonic() {
    StoreProvider.of<AppState>(context).dispatch(FetchRecoveryPhraseAction());
  }

  void _register() {
    if (_isConfirmed) {
      final String hashedMnemonic = _hashMnemonic(_mnemonic);
      StoreProvider.of<AppState>(context).dispatch(RegisterAction('userId', hashedMnemonic));
    } else {
      // Handle not confirmed
    }
  }

  String _hashMnemonic(String mnemonic) {
    var bytes = utf8.encode(mnemonic);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<int>(
          valueListenable: _currentPageNotifier,
          builder: (context, currentPage, _) {
            return Text(currentPage == 1 ? 'Confirm Recovery' : 'Register');
          },
        ),
        leading: IconButton(
          icon: const Icon(AntDesign.close),
          onPressed: () {
            Navigator.pop(context); // Exit the registration screen
          },
        ),
      ),
      body: StoreConnector<AppState, AuthState>(
        converter: (Store<AppState> store) => store.state.authState,
        builder: (context, authState) {
          if (authState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (authState.errorMessage != null) {
            return Center(child: Text('Error: ${authState.errorMessage}'));
          } else if (authState.mnemonic != null && _mnemonic.isEmpty) {
            _mnemonic = authState.mnemonic!;
          }

          return PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildMnemonicPage(),
              _buildConfirmationPage(context, _pageController, _mnemonic, _register),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMnemonicPage() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(AntDesign.key, size: 30),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'These words are the keys to your data',
                style: textTheme.bodyLarge,
              ),
            ),
            Center(
              child: Text(
                'Please write them down or store it somewhere safe',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 10),
            FlexibleHeightBox(
              gridWidth: 4,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                ),
                itemCount: 15,
                itemBuilder: (context, index) {
                  final words = _mnemonic.split(' ');
                  return Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('${index + 1}', style: textTheme.bodySmall),
                        ),
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200], // Adjust the color as needed
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            words[index],
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Store recovery phrase securely. '
              'Do not share it. '
              'Anyone with these words will have full access to your account. '
              'Losing it means losing your Teja account.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Center(
              child: Button(
                onPressed: () {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                text: 'Yes, I have saved it securely',
                buttonType: ButtonType.primary,
              ),
            ),
            Center(
              child: Button(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _mnemonic));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mnemonic copied to clipboard')),
                  );
                },
                icon: AntDesign.copy1,
                text: 'Copy to Clipboard',
                buttonType: ButtonType.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationPage(
      BuildContext context, PageController _pageController, String _mnemonic, VoidCallback _register) {
    List<String> mnemonicWords = _mnemonic.split(' ');
    int missingIndex = 0;
    String missingWord = '';

    // Initialize the mnemonic words and select a random missing word
    void initializeMnemonic() {
      missingIndex = 3 + (mnemonicWords.length - 7) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
      missingWord = mnemonicWords[missingIndex];
      mnemonicWords[missingIndex] = '____';
    }

    initializeMnemonic();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final textTheme = Theme.of(context).textTheme;

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlexibleHeightBox(
                gridWidth: 4,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: mnemonicWords.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 15,
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text('${index + 1}', style: textTheme.bodySmall),
                          ),
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200], // Adjust the color as needed
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              mnemonicWords[index],
                              style: textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter the missing word at position ${missingIndex + 1}',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null, // Show the error message if not empty
                ),
              ),
              const SizedBox(height: 16.0),
              Button(
                onPressed: () {
                  if (_textController.text.trim().toLowerCase() == missingWord.toLowerCase()) {
                    setState(() {
                      mnemonicWords[missingIndex] = missingWord;
                      _errorMessage = ''; // Clear the error message
                    });
                    _register();
                  } else {
                    setState(() {
                      _errorMessage = 'Wrong word entered. Please try again.'; // Set the error message
                    });
                  }
                },
                buttonType: ButtonType.primary,
                text: 'Register',
              ),
            ],
          ),
        );
      },
    );
  }
}
