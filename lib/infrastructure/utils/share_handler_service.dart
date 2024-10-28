import 'dart:async';
import 'package:share_handler/share_handler.dart';

class ShareHandlerService {
  StreamSubscription<SharedMedia>? _streamSubscription;
  SharedMedia? media;

  // Singleton pattern
  static final ShareHandlerService _instance = ShareHandlerService._internal();
  factory ShareHandlerService() => _instance;
  ShareHandlerService._internal();

  Future<void> init() async {
    final handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();
    _streamSubscription = handler.sharedMediaStream.listen((SharedMedia media) {
      this.media = media;
    });
  }

  // Clean up
  void dispose() {
    _streamSubscription?.cancel();
  }

  // Retrieve shared content details
  SharedMedia? get sharedMedia => media;
}
