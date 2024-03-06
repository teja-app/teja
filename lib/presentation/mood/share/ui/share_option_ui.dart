import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';
import 'package:share_plus/share_plus.dart';

class ShareOptionsButtons extends StatelessWidget {
  final GlobalKey globalKey;

  const ShareOptionsButtons({Key? key, required this.globalKey, required BuildContext context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Entypo.share),
          onPressed: () => _shareMoodAsImage('share', globalKey, context),
        ),
        IconButton(
          icon: const Icon(FontAwesome.instagram),
          onPressed: () => _shareMoodAsImage('instagram', globalKey, context),
        ),
        // Add more buttons for other platforms if necessary
      ],
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _shareMoodAsImage(String platform, GlobalKey globalKey, BuildContext context) async {
    try {
      final RenderObject? renderObject = globalKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject is RenderRepaintBoundary) {
        final ui.Image image = await renderObject.toImage(pixelRatio: 3.0);
        final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final imagePath = '${tempDir.path}/mood_share.png';
          final file = await File(imagePath).create();
          await file.writeAsBytes(pngBytes);
          // Share.shareXFiles([XFile(imagePath)]);
          if (platform == 'instagram') {
            // Share to Instagram
            SocialShare.shareInstagramStory(
              appId: "1701834726967769",
              imagePath: file.path,
            ).then((data) => ());
          } else if (platform == 'share') {
            Share.shareXFiles([XFile(imagePath)]);
          }
        } else {
          _showErrorSnackBar(context, 'Failed to capture mood image.');
        }
      } else {
        _showErrorSnackBar(context, 'Unable to find mood to share.');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Error sharing mood: ${e.toString()}');
    }
  }
}
