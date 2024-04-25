import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:teja/infrastructure/utils/voice_storage_helper.dart';

class AudioRecorderView extends StatefulWidget {
  final Function(String, String) onStopRecording;

  const AudioRecorderView({Key? key, required this.onStopRecording}) : super(key: key);

  @override
  _AudioRecorderViewState createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends State<AudioRecorderView> {
  bool _isRecording = false;
  final _audioRecorder = AudioRecorder();
  String _transcription = '';

  @override
  void initState() {
    super.initState();
  }

  void _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final path = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        print('Starting recording with path: $path');
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() => _isRecording = true);
      } else {
        print('Recording permission not granted.');
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  void _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      print('Stopped recording with path: $path');
      if (path != null) {
        try {
          final relativePath = await VoiceStorageHelper.saveVoicePermanently(path);
          print('Voice recording saved permanently with relative path: $relativePath');
          widget.onStopRecording(relativePath, _transcription);
        } catch (e) {
          print('Error saving voice recording: $e');
          // Handle the error and notify the user
          // Show an error message or provide an option to retry
        }
      } else {
        print('No voice recording path available.');
      }
      setState(() => _isRecording = false);
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() => _isRecording = false);
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _transcription = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      color: colorScheme.background,
      child: Column(
        children: [
          StreamBuilder<Amplitude>(
            stream: _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 300)),
            builder: (context, snapshot) {
              final amplitude = snapshot.data?.current ?? 0.0;
              return LinearProgressIndicator(
                value: amplitude.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: colorScheme.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(_transcription, style: textTheme.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            child: Icon(_isRecording ? Icons.stop : Icons.mic),
          ),
        ],
      ),
    );
  }
}
