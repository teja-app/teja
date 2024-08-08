import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/video_storage_helper.dart';
import 'package:teja/presentation/mood/ui/video_player_screen.dart';

class AttachmentVideo extends StatelessWidget {
  final String relativeVideoPath;
  double? width;
  double? height;

  AttachmentVideo({super.key, required this.relativeVideoPath, this.height = 100, this.width = 100});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: VideoStorageHelper.getVideo(relativeVideoPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return VideoPlayerScreen(
                    key: UniqueKey(),
                    videoFile: snapshot.data!,
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
        } else {
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
        }
      },
    );
  }
}
