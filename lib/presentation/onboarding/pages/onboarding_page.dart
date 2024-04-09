import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:rive/rive.dart';
import 'package:teja/presentation/onboarding/actions/init_state_actions.dart';
import 'package:teja/presentation/onboarding/ui/begin_button.dart';
import 'package:teja/presentation/onboarding/ui/onboarding_description.dart';
import 'package:teja/presentation/onboarding/ui/onboarding_header_image.dart';
import 'package:teja/presentation/onboarding/ui/onboarding_title.dart';
import 'package:teja/presentation/onboarding/ui/rive_animation_section.dart';
import 'package:teja/presentation/onboarding/widgets/authenticate.dart';
import 'package:teja/domain/redux/app_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  SMIInput<bool>? _isPressed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      performInitStateActions(store);
      if (_isPressed != null) {
        _isPressed!.value = false;
      }
    });
  }

  void _onButtonPressed() {
    authenticate(context, () {
      // This is the callback that gets called on successful authentication
      if (_isPressed != null) {
        _isPressed!.value = true; // Trigger the animation or perform additional actions
      }
      // Optionally, navigate to another page or perform additional logic post-authentication
    });
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

  @override
  Widget build(BuildContext context) {
    final Brightness themeBrightness = Theme.of(context).brightness;

    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OnboardingHeaderImage(themeBrightness: themeBrightness),
                  const SizedBox(height: 60),
                  const OnboardingTitle(), // Define this widget separately
                  const SizedBox(height: 20),
                  const OnboardingDescription(), // Define this widget separately
                  const SizedBox(height: 40),
                  RiveAnimationSection(onRiveInit: onRiveInit),
                  const SizedBox(height: 40),
                  BeginButton(onPressedCallback: _onButtonPressed),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
