import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/auth/auth_action.dart';
import 'package:teja/domain/redux/auth/auth_state.dart';
import 'package:teja/presentation/registration/ui/RecoveryCodeDisplay.dart';
import 'package:teja/router.dart';
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
  bool _isConfirmed = false;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  TextEditingController _textController = TextEditingController();
  String _errorMessage = '';
  bool _isFetchMnemonicCalled = false;
  int blankIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetchMnemonicCalled) {
      _fetchMnemonic();
      _isFetchMnemonicCalled = true;
    }
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
      StoreProvider.of<AppState>(context).dispatch(RegisterAction(_mnemonic));
    } else {
      // Handle not confirmed
      setState(() {
        _errorMessage = 'Please confirm your recovery phrase first.';
      });
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          } else if (authState.mnemonic != null && _mnemonic.isEmpty) {
            _mnemonic = authState.mnemonic!;
          } else if (authState.blankIndex != null) {
            blankIndex = authState.blankIndex!;
          }

          if (authState.isAuthSuccessful) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showSnackbar(context, 'Registration Successful!');
              GoRouter.of(context).goNamed(RootPath.root);
            });
          }

          return FutureBuilder<int>(
            future: Future.delayed(Duration.zero, () => authState.blankIndex ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                blankIndex = snapshot.data ?? 0;

                // return PageView(
                //   controller: _pageController,
                //   physics: const NeverScrollableScrollPhysics(),
                //   children: [
                //     _buildMnemonicPage(),
                //     _buildConfirmationPage(context, _pageController, _mnemonic,
                //         _confirmAndRegister, blankIndex),
                //   ],
                // );
                return PageStorage(
                  bucket: _bucket,
                  child: PageView(
                    key: const PageStorageKey('pageViewKey'),
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildMnemonicPage(),
                      _buildConfirmationPage(context, _pageController, _mnemonic, _confirmAndRegister, blankIndex),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMnemonicPage() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecoveryCodeDisplay(recoveryCode: _mnemonic!),
            Center(
              child: Button(
                onPressed: () {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                text: 'Yes, I have saved it securely',
                buttonType: ButtonType.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationPage(BuildContext context, PageController _pageController, String _mnemonic,
      VoidCallback _confirmAndRegister, int blankIndex) {
    List<String> mnemonicWords = _mnemonic.split(' ');
    String missingWord = '';

    final colorScheme = Theme.of(context).colorScheme;
    // Initialize the mnemonic words and select a random missing word
    void initializeMnemonic() {
      missingWord = mnemonicWords[blankIndex];
      mnemonicWords[blankIndex] = '____';
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
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('${index + 1}', style: textTheme.bodySmall),
                        ),
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            mnemonicWords[index],
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter the missing word at position ${blankIndex + 1}',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                ),
              ),
              const SizedBox(height: 16.0),
              Button(
                onPressed: () {
                  if (_textController.text.trim().toLowerCase() == missingWord.toLowerCase()) {
                    setState(() {
                      mnemonicWords[blankIndex] = missingWord;
                      _errorMessage = ''; // Clear the error message
                      _isConfirmed = true; // Update the confirmation status
                    });
                    _confirmAndRegister(); // Proceed with the registration
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

  void _confirmAndRegister() {
    if (_isConfirmed) {
      _register();
    }
  }
}
