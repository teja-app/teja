// lib/presentation/mood/ui/attachment_voice.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/voice_storage_helper.dart';
import 'package:teja/presentation/mood/ui/voice_player_screen.dart';

class AttachmentVoice extends StatelessWidget {
  final String relativeVoicePath;
  double? width;
  double? height;

  AttachmentVoice({super.key, required this.relativeVoicePath, this.height = 100, this.width = 100});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: VoiceStorageHelper.getVoice(relativeVoicePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return VoicePlayerScreen(
                      key: UniqueKey(),
                      voiceFile: snapshot.data!,
                    );
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(4),
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.error, color: Colors.red),
            );
          }
        }
        return Container(
          margin: const EdgeInsets.all(4),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}
