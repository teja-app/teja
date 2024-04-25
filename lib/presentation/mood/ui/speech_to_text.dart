import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class SpeechToTextView extends StatefulWidget {
  final Function(String) onTranscriptionUpdate;
  const SpeechToTextView({Key? key, required this.onTranscriptionUpdate}) : super(key: key);
  @override
  SpeechToTextViewState createState() => SpeechToTextViewState();
}

class SpeechToTextViewState extends State<SpeechToTextView> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _completeTranscription = '';
  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    _speechToText.initialize(onError: errorListener, onStatus: statusListener, debugLogging: true).then((initialized) {
      print('Speech to text service initialized: $initialized');
      setState(() {
        _isListening = initialized;
      });
    }).catchError((error) {
      print('Failed to initialize speech to text service: $error');
    });
  }

  void startListening() async {
    _completeTranscription = ''; // Reset transcription at the start
    await _speechToText.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 1000),
      pauseFor: const Duration(seconds: 10),
      onSoundLevelChange: soundLevelListener,
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.dictation,
      ),
    );
    print('Listening started');
    setState(() {
      _isListening = true;
    });
  }

  void stopListening() async {
    await _speechToText.stop();
    print('Listening stopped');
    setState(() {
      _isListening = false;
    });
    widget.onTranscriptionUpdate(_completeTranscription.trim());
  }

  void resultListener(SpeechRecognitionResult result) {
    if (result.finalResult) {
      _completeTranscription += result.recognizedWords + " "; // Add space for separation
      print('Final result received: ${result.recognizedWords}');
    } else {
      print('Intermediate result: ${result.recognizedWords}');
    }
  }

  void statusListener(String status) {
    print('Speech status update: $status');
    if (status == "notListening") {
      stopListening(); // Automatically stop listening when status is notListening
    }
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received speech recognition error: ${error.errorMsg}");
    setState(() {
      _isListening = false;
    });
  }

  void soundLevelListener(double level) {
// Optionally handle sound level changes
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isListening) Text('Listening...', style: Theme.of(context).textTheme.bodyMedium),
        IconButton(
          icon: Icon(_isListening ? Icons.stop : Icons.mic),
          onPressed: _isListening ? stopListening : startListening,
          tooltip: _isListening ? 'Tap to Stop' : 'Tap to Start',
        ),
      ],
    );
  }
}
