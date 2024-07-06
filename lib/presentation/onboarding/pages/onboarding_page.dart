import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:rive/rive.dart';
import 'package:teja/domain/redux/auth/auth_action.dart';
import 'package:teja/infrastructure/service/auth_service.dart';
import 'package:teja/presentation/onboarding/actions/init_state_actions.dart';
import 'package:teja/presentation/onboarding/ui/onboarding_description.dart';
import 'package:teja/presentation/onboarding/ui/onboarding_header_image.dart';
import 'package:teja/presentation/onboarding/ui/rive_animation_section.dart';
import 'package:teja/presentation/onboarding/widgets/authenticate.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  SMIInput<bool>? _isPressed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final store = StoreProvider.of<AppState>(context);
      bool _hasExistingMnemonic =
          await store.state.authState.hasExistingMnemonic;
      performInitStateActions(store);
      if (_isPressed != null) {
        _isPressed!.value = false;
      }

      // await SecureStorage().deleteRefreshToken();
      // await SecureStorage().deleteAccessToken();
      // await SecureStorage().deleteRecoveryCode();

      final recoverCode = await SecureStorage().readRecoveryCode();

      _hasExistingMnemonic = await store.dispatch(SetHasExistingMnemonicAction(
          _hasExistingMnemonic = recoverCode != null));

      final authSevice = AuthService();
      await authSevice.validateAndAuthenticate(store);
    });
  }

  void _onAuthenticatePressed() {
    authenticate(context, () {
      // This is the callback that gets called on successful authentication
      if (_isPressed != null) {
        _isPressed!.value =
            true; // Trigger the animation or perform additional actions
      }
      Future.delayed(const Duration(seconds: 3), () {
        GoRouter.of(context).replaceNamed(RootPath.home);
      });
      // Optionally, navigate to another page or perform additional logic post-authentication
    });
  }

  void _onRegisterPressed() {
    register(context, () {
      // This is the callback that gets called on successful registration
      if (_isPressed != null) {
        _isPressed!.value =
            true; // Trigger the animation or perform additional actions
      }
      Future.delayed(const Duration(seconds: 3), () {
        GoRouter.of(context).pushNamed(RootPath.registration);
      });
    });
  }

  void _onMusicPress() {
    GoRouter.of(context).pushNamed(RootPath.music);
  }

  void onRiveInit(Artboard artboard) {
    // Attempt to find a state machine controller by name
    final controller = StateMachineController.fromArtboard(artboard, 'unlock');
    if (controller != null) {
      artboard.addController(controller);
      _isPressed = controller.findInput<bool>('isPressed');
      if (_isPressed != null) {
        _isPressed!.value = false; // Initialize the input value as needed
      }
      artboard.addController(controller!);
      _isPressed = controller.findInput<bool>('isPressed') as SMIBool;
    }
  }

  void _onRecoverAccountPressed() {
    GoRouter.of(context).pushNamed(RootPath.recoveryAccount);
  }

  @override
  Widget build(BuildContext context) {
    final Brightness themeBrightness = Theme.of(context).brightness;
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: _onMusicPress,
                icon: const Icon(
                  Icons.music_note,
                  size: 16,
                ),
              )
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OnboardingHeaderImage(themeBrightness: themeBrightness),
                  const SizedBox(height: 30),
                  Text(
                    "Teja",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const OnboardingDescription(), // Define this widget separately
                  const SizedBox(height: 20),
                  RiveAnimationSection(onRiveInit: onRiveInit),
                  const SizedBox(height: 20),
                  Button(
                    key: const Key("letsBegin"),
                    text: "Let's Begin",
                    width: 300,
                    onPressed: _onAuthenticatePressed,
                  ),
                  if (!store.state.authState.hasExistingMnemonic) ...[
                    Button(
                      key: const Key("register"),
                      text: "Register (Anonymously)",
                      width: 300,
                      onPressed: _onRegisterPressed,
                      buttonType: ButtonType.primary,
                    ),
                    Button(
                      text: "Have a recovery code?",
                      width: 300,
                      onPressed:
                          _onRecoverAccountPressed, // Updated to navigate to recover account screen
                      buttonType: ButtonType.disabled,
                    )
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
