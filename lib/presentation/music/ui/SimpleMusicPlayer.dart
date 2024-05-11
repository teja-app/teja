import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
    final duration = _player.duration!;
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
        _isPlaying = false; // Audio has completed, set _isPlaying to false
      });
    } else {
      setState(() {
        _isPlaying = state.playing; // Update _isPlaying based on the playing state
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (_duration.inMilliseconds > 0)
              Text(
                '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 18),
              ),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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

  double _audioVolume = 1.0;
  double _musicVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _loadAudio();
    _player.playerStateStream.listen(_playerStateListener);
    _player.positionStream.listen(_positionListener);
  }

  Future<void> _loadAudio() async {
    const audioUrl = 'https://example.com/audio.mp3';
    const musicUrl = 'https://example.com/music.mp3';

    final audioSource = AudioSource.uri(Uri.parse(audioUrl));
    final musicSource = AudioSource.uri(Uri.parse(musicUrl));

    final playlist = PlaylistAudioSource([audioSource, musicSource]);
    await _player.setAudioSource(playlist);

    final duration = _player.duration!;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (_duration.inMilliseconds > 0)
              Text(
                '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 18),
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Audio Volume:'),
                Slider(
                  value: _audioVolume,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _audioVolume = value;
                      _player.setVolume(0, value);
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Music Volume:'),
                Slider(
                  value: _musicVolume,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _musicVolume = value;
                      _player.setVolume(1, value);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}