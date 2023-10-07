import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swayam/common/button.dart';

void main() async {
  final filePath = '.env.dev';
  final fileExists = await File(filePath).exists();
  print('File exists: $fileExists');
  await dotenv.load(fileName: filePath);
  final googleClientIdIos = dotenv.env['GOOGLE_CLIENT_ID_IOS'];
  final googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
  runApp(
    MyApp(
      googleClientIdIos: googleClientIdIos,
      googleServerClientId: googleServerClientId,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? googleClientIdIos;
  final String? googleServerClientId;

  MyApp({this.googleClientIdIos, this.googleServerClientId});
  @override
  Widget build(BuildContext context) {
    final googleSignIn = GoogleSignIn(
      clientId: googleClientIdIos,
      serverClientId: googleServerClientId,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnboardingPage(googleSignIn: googleSignIn),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final GoogleSignIn googleSignIn;

  OnboardingPage({required this.googleSignIn});

  Future<void> _handleSignIn() async {
    try {
      final user = await googleSignIn.signIn();
      print('User signed in: $user');
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> _handleSignOut() async {
    googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo/AppIcon.png', // Replace this line with your logo asset path
          fit: BoxFit.cover,
          height: 30, // You can adjust the height as needed
        ),
        centerTitle: true, // This will center your logo
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SliderWidget(), // Your custom slider widget
          ),
          Expanded(
            flex: 1,
            key: const Key("buttonContainer"),
            child: Container(
              alignment: Alignment.center, // This line centers the children
              color: Colors.grey[200], // Set new background color here
              width: double
                  .infinity, // This line makes the container occupy the entire width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                    text: 'Continue with Google',
                    onPressed: _handleSignIn,
                    buttonType: ButtonType.primary,
                    width: 300,
                  ),
                  Button(
                    text: 'Sign up with email',
                    width: 300,
                    onPressed: () {
                      // Navigate to email sign up page
                    },
                    buttonType: ButtonType.secondary,
                  ),
                  Button(
                    text: 'Login',
                    width: 200,
                    onPressed: () {
                      // Navigate to login page
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class Slide {
  final String title;
  final String image;

  Slide({
    required this.title,
    required this.image,
  })  : assert(title.isNotEmpty, 'Title cannot be empty'),
        assert(image.isNotEmpty, 'Image path cannot be empty');
}

class _SliderWidgetState extends State<SliderWidget> {
  List<Slide> slides = [
    Slide(
      title: "Embark on a journey to clarity.",
      image: "assets/welcome/DiscoverClarity.jpeg",
    ),
    Slide(
      title: "Unveil the power of expression.",
      image: "assets/welcome/EmbraceExpression.jpeg",
    ),
    Slide(
      title: "Unwind in a haven of calm.",
      image: "assets/welcome/CultivateCalm.jpeg",
    ),
    Slide(
      title: "Nurture meaningful connections.",
      image: "assets/welcome/CultivateConnections.jpeg",
    ),
  ];

  final PageController _pageController = PageController();
  late Timer _timer;
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      final currentPage = (_pageController.page ?? 0).round();
      if (currentPage == slides.length - 1) {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pageController.addListener(() {
      if (_pageController.position.userScrollDirection ==
          ScrollDirection.idle) {
        if (!_timer.isActive) {
          // Wait for 10 seconds before restarting the auto-slide
          Future.delayed(Duration(seconds: 10), () {
            // Only restart the timer if the user hasn't started scrolling again
            if (_pageController.position.userScrollDirection ==
                ScrollDirection.idle) {
              _startTimer();
            }
          });
        }
      } else {
        // Cancel the timer if user is scrolling
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer
    _pageController.dispose(); // Dispose the page controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: slides.length,
      itemBuilder: (context, index) {
        return Column(
          key: Key(index.toString()),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Your text color
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    slides[index].title,
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 75),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(slides[index].image),
                radius: 150,
              ),
            ),
          ],
        );
      },
    );
  }
}
