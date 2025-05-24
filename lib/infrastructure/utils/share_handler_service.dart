import 'dart:async';
import 'package:share_handler/share_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:teja/shared/helpers/logger.dart';

class ShareHandlerService {
  StreamSubscription<SharedMedia>? _streamSubscription;
  SharedMedia? media;
  BuildContext? _context;

  static final ShareHandlerService _instance = ShareHandlerService._internal();
  factory ShareHandlerService() => _instance;
  ShareHandlerService._internal();

  // Add this method to set context
  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> init() async {
    final handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();
    if (media != null) {
      _processSharedMedia(media!);
    }

    _streamSubscription = handler.sharedMediaStream.listen((SharedMedia media) {
      this.media = media;
      _processSharedMedia(media);
    });
  }

  Future<void> _processSharedMedia(SharedMedia media) async {
    if (media.content != null && _isValidUrl(media.content!)) {
      _navigateToQuickJournal(media.content!);
    } else if (media.content != null) {
      _navigateToQuickJournal(null);
    }
  }

  void _navigateToQuickJournal(
    String? url,
  ) {
    try {
      if (_context != null && _context!.mounted) {
        GoRouter.of(_context!).pushNamed('quickJournalEntry', extra: {
          'heroTag': 'quickInputHero',
          'sharedContent': true,
          'url': url,
        });
      }
    } catch (e) {
      logger.e('Failed to navigate to quick journal', error: e);
    }
  }

  bool _isValidUrl(String text) {
    try {
      final uri = Uri.parse(text);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _streamSubscription?.cancel();
  }

  SharedMedia? get sharedMedia => media;
}
