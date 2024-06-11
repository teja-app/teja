import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/infrastructure/api/mood_suggestion_api.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class AISuggestionButton extends StatefulWidget {
  final MoodLogEntity selectedMoodLog;

  const AISuggestionButton({Key? key, required this.selectedMoodLog}) : super(key: key);

  @override
  _AISuggestionButtonState createState() => _AISuggestionButtonState();
}

class _AISuggestionButtonState extends State<AISuggestionButton> {
  String? suggestions;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getSuggestions() async {
    setState(() {
      isLoading = true;
      suggestions = null;
      errorMessage = null;
    });

    try {
      final authToken = await SecureStorage().readAccessToken();
      if (authToken == null) {
        setState(() {
          errorMessage = 'Authorization token not found';
          isLoading = false;
        });
        return;
      }

      final moodData = {
        'moodDetail': (
          "Rating: ${widget.selectedMoodLog.moodRating}/5 \n"
              "Description: ${widget.selectedMoodLog.comment} \n"
              "Timestamp: ${widget.selectedMoodLog.timestamp} \n"
              "Factors: ${widget.selectedMoodLog.factors} \n"
              "Feelings: ${widget.selectedMoodLog.feelings?.map((f) => f.feeling).toList()} \n",
        ).toString(),
      };

      final response = await MoodSuggestionAPI().fetchAISuggestions(authToken, moodData);
      if (response.statusCode == 201) {
        setState(() {
          suggestions = response.data['suggestions'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to get suggestions';
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        errorMessage = 'An error occurred';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Button(
          text: "Suggestion",
          icon: Icons.favorite,
          onPressed: getSuggestions,
        ),
        if (isLoading) const Center(child: CircularProgressIndicator()),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (suggestions != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MarkdownBody(
              data: suggestions!,
            ),
          ),
      ],
    );
  }
}
