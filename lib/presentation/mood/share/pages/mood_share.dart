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
              : const Center(child: Text('Mood not found')),
        );
      },
    );
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
