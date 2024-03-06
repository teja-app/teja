import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:teja/presentation/mood/share/ui/share_option_ui.dart';
import 'package:teja/presentation/mood/ui/mood_detail_card.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class MoodSharePage extends StatefulWidget {
  final String moodId;

  const MoodSharePage({Key? key, required this.moodId}) : super(key: key);

  @override
  _MoodSharePageState createState() => _MoodSharePageState();
}

class _MoodSharePageState extends State<MoodSharePage> {
  final GlobalKey _globalKey = GlobalKey();
  bool _includeComments = true; // Default to true
  bool _includeAttachments = true; // Default to true

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MoodLogEntity?>(
      converter: (store) => MoodShareViewModel.fromStore(store, widget.moodId),
      builder: (_, moodLog) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Share Mood'),
          ),
          body: moodLog != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: _globalKey,
                        child: FlexibleHeightBox(
                          gridWidth: 4,
                          child: moodLogLayout(
                            moodLog,
                            context,
                            MoodLogLayoutConfig(
                              includeComments: _includeComments,
                              includeAttachments: _includeAttachments,
                            ),
                          ),
                        ),
                      ),
                      SwitchListTile(
                        title: const Text("Include Comments"),
                        value: _includeComments,
                        onChanged: (bool value) {
                          setState(() {
                            _includeComments = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text("Include Attachments"),
                        value: _includeAttachments,
                        onChanged: (bool value) {
                          setState(() {
                            _includeAttachments = value;
                          });
                        },
                      ),
                      ShareOptionsButtons(context: context, globalKey: _globalKey), // Adjusted to pass the GlobalKey
                    ],
                  ),
                )
              : Center(child: Text('Mood not found')),
        );
      },
    );
  }

  Future<void> _shareMood(BuildContext context) async {
    try {
      final RenderObject? renderObject = _globalKey.currentContext?.findRenderObject();
      if (renderObject != null && renderObject is RenderRepaintBoundary) {
        final ui.Image image = await renderObject.toImage(pixelRatio: 3.0);
        final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final imagePath = '${tempDir.path}/mood_share.png';
          final file = await File(imagePath).create();
          await file.writeAsBytes(pngBytes);
          Share.shareXFiles([XFile(imagePath)]);
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

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class MoodShareViewModel {
  static MoodLogEntity? fromStore(Store<AppState> store, String moodId) {
    return store.state.moodDetailPage.selectedMoodLog;
  }
}
