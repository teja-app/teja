import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/quote_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'dart:math' as math;
import 'package:teja/presentation/quotes/quote_view.dart';
import 'package:social_share/social_share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teja/shared/common/bento_box.dart';

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
    style: QuoteStyle(textStyle: GoogleFonts.tomorrow(color: Colors.green[900], fontSize: 10.0), spacing: 20.0),
    alignment: Alignment.topCenter,
    isLogoAtTop: false,
  ),
  // Add more styles and backgrounds as needed
];

class RandomQuotePage extends StatefulWidget {
  @override
  _RandomQuotePageState createState() => _RandomQuotePageState();
}

class _RandomQuotePageState extends State<RandomQuotePage> {
  final GlobalKey _globalKey = GlobalKey();
  int currentBackgroundIndex = 1;

  QuoteEntity? randomQuote;

  @override
  void initState() {
    super.initState();
    // Initially fetch a random quote when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRandomQuote();
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    // Initially fetch a random quote when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRandomQuote();
    });
  }

  void changeBackground() {
    setState(() {
      currentBackgroundIndex = (currentBackgroundIndex + 1) % backgrounds.length;
    });
  }

  void _getRandomQuote() {
    final store = StoreProvider.of<AppState>(context);
    setState(() {
      randomQuote = _ViewModel.fromStore(store).getRandomQuote();
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

  @override
  Widget build(BuildContext context) {
    var currentBackground = backgrounds[currentBackgroundIndex];
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              randomQuote == null
                  ? const Center(child: Text("No quotes available."))
                  : RepaintBoundary(
                      key: _globalKey,
                      child: BentoBox(
                        gridWidth: 4,
                        gridHeight: 5,
                        padding: 0,
                        child: QuoteView(
                          quoteText: randomQuote!.text,
                          quoteAuthor: randomQuote!.author,
                          style: currentBackground.style,
                          background: AssetImage(currentBackground.imagePath),
                          alignment: currentBackground.alignment,
                          isLogoAtTop: currentBackground.isLogoAtTop,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle),
                      onPressed: _getRandomQuote,
                    ),
                    IconButton(
                      icon: const Icon(FontAwesome.instagram),
                      onPressed: () => _shareQuoteAsImage(platform: 'instagram'),
                    ),
                    IconButton(
                      icon: const Icon(Entypo.share),
                      onPressed: () => _shareQuoteAsImage(platform: 'share'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: changeBackground,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final List<QuoteEntity> quotes;

  _ViewModel({required this.quotes});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      quotes: store.state.quoteState.quotes,
    );
  }

  QuoteEntity? getRandomQuote() {
    if (quotes.isEmpty) return null;
    final randomIndex = math.Random().nextInt(quotes.length);
    return quotes[randomIndex];
  }
}
