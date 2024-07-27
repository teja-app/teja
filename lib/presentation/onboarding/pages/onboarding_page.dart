import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:rive/rive.dart';
import 'package:palette_generator/palette_generator.dart';
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
  bool _isProUser = false;
  Color _buttonBackgroundColor = Colors.black;
  Color _buttonTextColor = Colors.white;
  Color _borderColor = Colors.white;
  String _affirmation = "You are capable, worthy, and have the strength to overcome challenges.";

  final String _imageUrl =
      'https://cdn.leonardo.ai/users/289152d8-6132-4fd8-b895-28a873a1f7d9/generations/cb138ac0-a863-452e-a971-045121441bf9/Default_A_delicate_serene_landscape_artwork_meticulously_craft_3.jpg?w=512';

  @override
  void initState() {
    super.initState();
    _updateButtonColors();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final store = StoreProvider.of<AppState>(context);
      bool _hasExistingMnemonic = await store.state.authState.hasExistingMnemonic;
      performInitStateActions(store);
      if (_isPressed != null) {
        _isPressed!.value = false;
      }

      final recoverCode = await SecureStorage().readRecoveryCode();

      _hasExistingMnemonic =
          await store.dispatch(SetHasExistingMnemonicAction(_hasExistingMnemonic = recoverCode != null));

      final authService = AuthService();
      await authService.validateAndAuthenticate(store);
    });
  }

  Future<void> _updateButtonColors() async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(_imageUrl),
    );
    setState(() {
      _buttonBackgroundColor = paletteGenerator.dominantColor?.color ?? Colors.black;
      _buttonTextColor = paletteGenerator.dominantColor?.bodyTextColor ?? Colors.white;
      _borderColor = paletteGenerator.dominantColor?.bodyTextColor ?? Colors.white;
    });
  }

  void _onAuthenticatePressed() {
    authenticate(context, () {
      if (_isPressed != null) {
        _isPressed!.value = true;
      }
      Future.delayed(const Duration(seconds: 3), () {
        GoRouter.of(context).replaceNamed(RootPath.home);
      });
    });
  }

  void _onRegisterPressed() {
    register(context, () {
      if (_isPressed != null) {
        _isPressed!.value = true;
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
    final controller = StateMachineController.fromArtboard(artboard, 'unlock');
    if (controller != null) {
      artboard.addController(controller);
      _isPressed = controller.findInput<bool>('isPressed') as SMIBool?;
      if (_isPressed != null) {
        _isPressed!.value = false;
      }
    }
  }

  void _onRecoverAccountPressed() {
    GoRouter.of(context).pushNamed(RootPath.recoveryAccount);
  }

  @override
  Widget build(BuildContext context) {
    final Brightness themeBrightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              IconButton(
                onPressed: _onMusicPress,
                icon: Icon(
                  Icons.music_note,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ),
              // Switch(
              //   value: _isProUser,
              //   onChanged: (value) {
              //     setState(() {
              //       _isProUser = value;
              //     });
              //   },
              // ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              _isProUser ? _buildProUserView(context) : _buildDefaultView(context, store, themeBrightness),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProUserView(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          _imageUrl,
          fit: BoxFit.cover,
        ),

        // Semi-transparent overlay
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.2),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 50), // Spacer at the top
              // Centered Affirmation
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _buttonBackgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _affirmation,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _buttonTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Button at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Button(
                  key: const Key("letsBegin"),
                  text: "Let's Begin",
                  width: 300,
                  onPressed: _onAuthenticatePressed,
                  buttonRadius: 24,
                  backgroundColor: _buttonBackgroundColor,
                  textColor: _buttonTextColor,
                  borderColor: _borderColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultView(BuildContext context, Store<AppState> store, Brightness themeBrightness) {
    return Center(
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
            const OnboardingDescription(),
            const SizedBox(height: 20),
            RiveAnimationSection(onRiveInit: onRiveInit),
            const SizedBox(height: 20),
            Button(
              buttonType: ButtonType.primary,
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
                onPressed: _onRecoverAccountPressed,
                buttonType: ButtonType.disabled,
              )
            ]
          ],
        ),
      ),
    );
  }
}
