import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';

Future<void> _showSuggestionOptions(BuildContext context) async {
  final type = await showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: const Text('Idea'),
              onTap: () => Navigator.of(context).pop('ideas'),
            ),
            ListTile(
              leading: const Icon(Icons.chair_alt_outlined),
              title: const Text('Challenge'),
              onTap: () => Navigator.of(context).pop('challenge'),
            ),
            // Add more options as needed
          ],
        ),
      );
    },
  );

  if (type != null) {
    _fetchAndDisplaySuggestions(type);
  }
}

Future<void> _fetchAndDisplaySuggestions(BuildContext context, String guidanceType) async {
  // Access the viewModel for the current state.
  final viewModel = StoreProvider.of<AppState>(context).state.journalEditorState.currentJournalEntry;
  final templateModel = StoreProvider.of<AppState>(context).state.journalTemplateState;

  String journalTitle = "Default Title";
  if (viewModel?.templateId != null) {
    journalTitle = templateModel.templatesById[viewModel?.templateId]!.title;
  }
  final String journalPrompt =
      viewModel?.questions?[widget.questionIndex].questionText ?? "Default Description"; // Fallback description
  final String userInput = textEditingController.text ?? "No Input"; // Directly use the user's current input
  try {
    final Dio dio = Dio();
    final response = await dio.post(
      'https://lively-darkness-d1b6.ray-719.workers.dev',
      data: {
        "journalTitle": journalTitle,
        "journalPrompt": journalPrompt,
        "guidanceType": guidanceType,
        "userInput": userInput,
      },
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );

    if (response.statusCode == 200) {
      print("response.data ${response.data}");
      final List<String> fetchedSuggestions = [
        response.data as String
      ]; // Modify this line based on the actual data structure
      setState(() {
        suggestions = fetchedSuggestions;
      });
    } else {
      print("Failed to fetch suggestions: ${response.statusMessage}");
    }
  } catch (e) {
    print("Error making the request: $e");
  }
}
