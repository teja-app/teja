import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';

class SimplePlayerScreen extends StatefulWidget {
  const SimplePlayerScreen({super.key});

  @override
  _SimplePlayerScreenState createState() => _SimplePlayerScreenState();
}

class _SimplePlayerScreenState extends State<SimplePlayerScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _backgroundPlayer = AudioPlayer();
  final _audioPlayer = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  double _backgroundVolume = 1.0;
  double _audioVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _loadBackgroundAudio();
    _loadAudio();
    _backgroundPlayer.playerStateStream.listen(_playerStateListener);
    _backgroundPlayer.positionStream.listen(_positionListener);
    _audioPlayer.playerStateStream.listen(_playerStateListener);
    _audioPlayer.positionStream.listen(_positionListener);
  }

  Future<void> _loadBackgroundAudio() async {
    const backgroundUrl = 'https://f000.backblazeb2.com/file/platfom-static/Meditative.mp3';
    final backgroundSource = AudioSource.uri(Uri.parse(backgroundUrl));
    await _backgroundPlayer.setAudioSource(backgroundSource);
  }

  Future<void> _loadAudio() async {
    const audioUrl =
        'https://f000.backblazeb2.com/file/platfom-static/ElevenLabs_2024-05-12T09_39_24_Jameson+-+Guided+Meditation+%26+Narration_pvc_s50_sb100_t2.mp3';
    final audioSource = AudioSource.uri(Uri.parse(audioUrl));
    await _audioPlayer.setAudioSource(audioSource);
    final duration = _audioPlayer.duration;
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

  void _togglePlayPause() {
    if (_isPlaying) {
      _backgroundPlayer.pause();
      _audioPlayer.pause();
    } else {
      _backgroundPlayer.play();
      _audioPlayer.play();
    }
  }

  void _stopAudio() {
    _backgroundPlayer.stop();
    _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
      _isPlaying = false;
    });
  }

  void _setBackgroundVolume(double volume) {
    _backgroundPlayer.setVolume(volume);
    setState(() {
      _backgroundVolume = volume;
    });
  }

  void _setAudioVolume(double volume) {
    _audioPlayer.setVolume(volume);
    setState(() {
      _audioVolume = volume;
    });
  }

  @override
  Widget build(BuildContext context) {
    final durationText =
        '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(durationText),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Background Volume'),
            Slider(
              value: _backgroundVolume,
              onChanged: _setBackgroundVolume,
            ),
            const SizedBox(height: 16),
            const Text('Audio Volume'),
            Slider(
              value: _audioVolume,
              onChanged: _setAudioVolume,
            ),
          ],
        ),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                    onPressed: _togglePlayPause,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 42,
                    icon: const Icon(Icons.stop),
                    onPressed: _stopAudio,
                    color: Colors.white,
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
    _backgroundPlayer.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
