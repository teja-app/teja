import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teja/domain/entities/quote_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/quotes/quote_view.dart';
import 'package:social_share/social_share.dart';
import 'package:share_plus/share_plus.dart';

class BackgroundStyle {
  final String imagePath;
  final QuoteStyle style;
  final Alignment alignment;
  final bool isLogoAtTop;

  BackgroundStyle({required this.imagePath, required this.style, required this.alignment, required this.isLogoAtTop});
}

List<BackgroundStyle> backgrounds = [
  BackgroundStyle(
    imagePath: 'assets/quotes/background_1.png',
    style: QuoteStyle(textStyle: GoogleFonts.abhayaLibre(color: Colors.brown, fontSize: 24.0), spacing: 30.0),
    alignment: Alignment.center,
    isLogoAtTop: true,
  ),
  BackgroundStyle(
    imagePath: 'assets/quotes/background_2.png',
    style: QuoteStyle(textStyle: GoogleFonts.tomorrow(color: Colors.green[900], fontSize: 24.0), spacing: 20.0),
    alignment: Alignment.center,
    isLogoAtTop: false,
  ),
  // Add more styles and backgrounds as needed
];

class _ViewModel {
  final List<QuoteEntity> quotes;

  _ViewModel({required this.quotes});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      quotes: store.state.quoteState.quotes,
    );
  }

// Gets a list of 10 unique random quotes.
  /// If there are not enough quotes for a set of 10, it returns what is available.
  List<QuoteEntity> getRandomQuotes(int count) {
    if (quotes.isEmpty) return [];
    var randomSet = <QuoteEntity>{};
    var random = Random();
    // Loop until the set contains 10 unique quotes or the entire list if it contains fewer than 10 quotes.
    while (randomSet.length < count && randomSet.length < quotes.length) {
      var randomIndex = random.nextInt(quotes.length);
      randomSet.add(quotes[randomIndex]);
    }
    return randomSet.toList();
  }
}

class RandomQuotePage extends StatefulWidget {
  @override
  _RandomQuotePageState createState() => _RandomQuotePageState();
}

class _RandomQuotePageState extends State<RandomQuotePage> {
  final GlobalKey _globalKey = GlobalKey();
  final PageController _pageController = PageController();

  int currentBackgroundIndex = 0;

  QuoteEntity? randomQuote;

  void changeBackground() {
    setState(() {
      currentBackgroundIndex = (currentBackgroundIndex + 1) % backgrounds.length;
    });
  }

  Future<void> _shareQuoteAsImage({required String platform}) async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/quote.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(pngBytes);
        if (platform == 'instagram') {
          // Share to Instagram
          SocialShare.shareInstagramStory(
            appId: "1701834726967769",
            imagePath: imageFile.path,
          ).then((data) => ());
        } else if (platform == 'share') {
          Share.shareXFiles([XFile(imagePath)]);
        }
      }
    } catch (e) {
      print('error: $e');
    }
  }

  Widget _roundedIconButton(IconData icon, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: IconButton(
        icon: Icon(icon),
        color: colorScheme.surface,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentBackground = backgrounds[currentBackgroundIndex];

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final quotes = vm.getRandomQuotes(10);
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: SmoothPageIndicator(
              controller: _pageController,
              count: quotes.length,
              effect: const ExpandingDotsEffect(),
              onDotClicked: (index) => _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(right: 12, left: 4),
              child: _roundedIconButton(Icons.arrow_back, () => Navigator.of(context).pop()),
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index % quotes.length]; // This line provides the "infinite" effect.
              return GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) {
                  // Check the horizontal velocity of the drag to determine swipe direction
                  if (details.primaryVelocity! < 0) {
                    // User swiped Left
                    // Navigate to the next page if not at the end of the list
                    if (index < vm.quotes.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease,
                      );
                    }
                  } else if (details.primaryVelocity! > 0) {
                    // User swiped Right
                    // Navigate to the previous page if not at the beginning of the list
                    if (index > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease,
                      );
                    }
                  }
                },
                child: Stack(
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: QuoteView(
                          quoteText: quote!.text,
                          quoteAuthor: quote!.author,
                          style: currentBackground.style,
                          background: AssetImage(currentBackground.imagePath),
                          alignment: currentBackground.alignment,
                          isLogoAtTop: currentBackground.isLogoAtTop,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _roundedIconButton(FontAwesome.instagram, () => _shareQuoteAsImage(platform: 'instagram')),
                          _roundedIconButton(Entypo.share, () => _shareQuoteAsImage(platform: 'share')),
                          _roundedIconButton(Entypo.palette, changeBackground),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
