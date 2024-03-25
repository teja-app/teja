import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:rive/rive.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/actions.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/domain/redux/journal/journal_template/actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/domain/redux/quotes/quote_action.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FetchMasterFeelingsActionFromApi());
      store.dispatch(FetchMasterFactorsActionFromApi());
      store.dispatch(FetchQuotesActionFromApi());
      store.dispatch(FetchJournalTemplatesActionFromApi());
      store.dispatch(FetchFeaturedJournalTemplatesActionFromApi());
      store.dispatch(FetchJournalCategoriesActionFromApi());

      // Cache Fetch
      store.dispatch(FetchMasterFeelingsActionFromCache());
      store.dispatch(FetchMasterFactorsActionFromCache());
      store.dispatch(FetchQuotesActionFromCache());
      store.dispatch(FetchJournalTemplatesActionFromCache());
      store.dispatch(FetchFeaturedJournalTemplatesActionFromCache());
      store.dispatch(FetchJournalCategoriesActionFromCache());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness themeBrightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    SMIInput<bool>? _isPressed;

    void _onRiveInit(Artboard artboard) {
      final controller = StateMachineController.fromArtboard(
        artboard,
        'unlock',
      );
      artboard.addController(controller!);
      _isPressed = controller.findInput<bool>('isPressed') as SMIBool;
    }

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
                  // Image or SVG just above the title
                  SvgPicture.asset(
                    themeBrightness == Brightness.dark ? "assets/logo/White.svg" : "assets/logo/Color.svg",
                    width: 80, // Adjust the size as needed
                    height: 80,
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Personal way to bloom",
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Discover your journey towards a balanced life with personalized journaling, mood tracking, and self-improvement strategies.",
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FlexibleHeightBox(
                    gridWidth: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 75,
                          width: 75, // Set a width for the Rive animation for consistent sizing
                          child: RiveAnimation.asset('assets/welcome/safe_icon.riv', onInit: _onRiveInit),
                        ),
                        Expanded(
                          // Use Expanded to ensure the text takes the remaining space
                          child: Text(
                            "All your data is securely stored locally on your mobile device, ensuring your information remains private and accessible only to you.",
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Button(
                    key: const Key("homePage"),
                    text: "Let's Begin",
                    width: 300,
                    onPressed: () {
                      _isPressed?.value = true;
                      Future.delayed(const Duration(seconds: 2), () {
                        GoRouter.of(context).replaceNamed(RootPath.home);
                      });
                    },
                  ),
                  const SizedBox(height: 20), // Add spacing at the bottom for better layout
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
