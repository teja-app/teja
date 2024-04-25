// lib/presentation/mood/ui/voice_player_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class VoicePlayerScreen extends StatefulWidget {
  final File voiceFile;

  const VoicePlayerScreen({required Key key, required this.voiceFile}) : super(key: key);

  @override
  _VoicePlayerScreenState createState() => _VoicePlayerScreenState();
}

class _VoicePlayerScreenState extends State<VoicePlayerScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setFilePath(widget.voiceFile.path);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 64.0,
                    height: 64.0,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 64.0,
                    onPressed: _audioPlayer.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 64.0,
                    onPressed: _audioPlayer.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 64.0,
                    onPressed: () => _audioPlayer.seek(Duration.zero),
                  );
                }
              },
            ),
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream.map((duration) => duration),
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero; // This should always be non-null now
                return StreamBuilder<Duration>(
                  stream: _audioPlayer.durationStream.map((duration) => duration ?? Duration.zero),
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero; // This should always be non-null now
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ProgressBar(
                        progress: position,
                        total: duration,
                        onSeek: (position) {
                          _audioPlayer.seek(position);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
