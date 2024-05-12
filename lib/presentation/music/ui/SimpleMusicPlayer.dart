import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';

class SimplePlayerScreen extends StatefulWidget {
  const SimplePlayerScreen({super.key});

  @override
  _SimplePlayerScreenState createState() => _SimplePlayerScreenState();
}

class _SimplePlayerScreenState extends State<SimplePlayerScreen> {
  final _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadAudio();
    _player.playerStateStream.listen(_playerStateListener);
    _player.positionStream.listen(_positionListener);
  }

  Future<void> _loadAudio() async {
    const url = 'https://cdn1.suno.ai/810e8168-807f-479f-abd9-75eb848def4f.mp3';
    final audioSource = AudioSource.uri(Uri.parse(url));
    await _player.setAudioSource(audioSource);
    final duration = _player.duration;
    if (duration != null) {
      setState(() {
        _duration = duration;
      });
    }
  }

  void _playerStateListener(PlayerState state) {
    if (state.processingState == ProcessingState.completed) {
      setState(() {
        _position = _duration;
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = state.playing;
      });
    }
  }

  void _positionListener(Duration position) {
    setState(() {
      _position = position;
    });
  }

  void _seekToPosition(Duration position) {
    _player.seek(position);
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final durationText =
        '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(durationText),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/music/cosmos_transparent.riv',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_duration.inMilliseconds > 0)
                Slider(
                  value: _position.inMilliseconds.toDouble(),
                  min: 0,
                  max: _duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    _seekToPosition(Duration(milliseconds: value.toInt()));
                  },
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _togglePlayPause,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
