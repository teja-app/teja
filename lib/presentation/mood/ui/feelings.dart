import 'dart:convert';

import 'package:flutter/services.dart';

class Mood {
  static const veryUnpleasant = 1;
  static const unpleasant = 2;
  static const neutral = 3;
  static const pleasant = 4;
  static const veryPleasant = 5;
}

class Emotion {
  final String id;
  final String name;
  final int mood;
  final List<String> similarWords;

  Emotion(this.id, this.name, this.mood, this.similarWords);
}

const emotionTitle = {
  Mood.veryPleasant: "Very Pleasent",
  Mood.pleasant: "Pleasent",
  Mood.unpleasant: "Unpleasent",
  Mood.veryUnpleasant: "Very Unpleasent",
  Mood.neutral: "Neutral",
};

// Function to load the emotionList from feelings.json
Future<List<Emotion>> loadEmotionList() async {
  try {
    final jsonString = await rootBundle.loadString('assets/mood/feelings.json');
    final jsonData = json.decode(jsonString);
    final emotionData = jsonData as List<dynamic>;

    final emotionList = emotionData.map((data) {
      final id = data['id'];
      final name = data['name'];
      final mood = data['mood'];
      final similarWords = List<String>.from(data['similarWords'] ?? []);
      return Emotion(id, name, mood, similarWords);
    }).toList();

    return emotionList;
  } catch (e) {
    print('Error loading emotionList: $e');
    return [];
  }
}

void main() async {
  final emotionList = await loadEmotionList();
  if (emotionList.isNotEmpty) {
    // Now you can use the emotionList in your Dart code
    for (final emotion in emotionList) {
      print('${emotion.name}: ${emotion.mood}');
    }
  } else {
    print('Emotion list is empty or could not be loaded.');
  }
}
