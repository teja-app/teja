import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/onboarding/actions.dart';
import 'package:swayam/presentation/onboarding/widgets/slider_widget.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/common/bento_box.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:swayam/domain/redux/app_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _handleGoogleSignIn(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(GoogleSignInAction());
  }

  @override
  Widget build(BuildContext context) {
    final Brightness themeBrightness = Theme.of(context).brightness;
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            title: SvgPicture.asset(
              themeBrightness == Brightness.dark
                  ? "assets/logo/White.svg"
                  : "assets/logo/Color.svg",
              width: 40,
              height: 40,
            ),
          ),
          body: Column(
            children: [
              const BentoBox(
                gridWidth: 4,
                gridHeight: 4,
                child: SizedBox(
                  // Replace Expanded with SizedBox
                  height: 400, // Set an appropriate height
                  child: SliderWidget(),
                ),
              ),
              Expanded(
                flex: 1,
                key: const Key("buttonContainer"),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (!Platform.isWindows &&
                          !Platform.isMacOS &&
                          !Platform
                              .isLinux) // Check if the platform is not desktop
                        Button(
                          key: const Key("googleButton"),
                          text: 'Continue with Google',
                          onPressed: () => _handleGoogleSignIn(context),
                          buttonType: ButtonType.primary,
                          width: 300,
                        ),
                      Button(
                        key: const Key("signUp"),
                        text: 'Sign up with email',
                        width: 300,
                        onPressed: () => GoRouter.of(context).push('/sign_up'),
                        buttonType: ButtonType.secondary,
                      ),
                      Button(
                          key: const Key("login"),
                          text: 'Log in',
                          width: 200,
                          onPressed: () =>
                              GoRouter.of(context).pushNamed(RootPath.signIn))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
