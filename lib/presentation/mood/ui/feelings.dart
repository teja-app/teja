import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:swayam/domain/entities/master_feeling.dart';

class Mood {
  static const veryUnpleasant = 1;
  static const unpleasant = 2;
  static const neutral = 3;
  static const pleasant = 4;
  static const veryPleasant = 5;
}

const emotionTitle = {
  Mood.veryPleasant: "Very Pleasent",
  Mood.pleasant: "Pleasent",
  Mood.unpleasant: "Unpleasent",
  Mood.veryUnpleasant: "Very Unpleasent",
  Mood.neutral: "Neutral",
};

// Function to load the emotionList from feelings.json
Future<List<MasterFeeling>> loadEmotionList() async {
  try {
    final jsonString = await rootBundle.loadString('assets/mood/feelings.json');
    final jsonData = json.decode(jsonString);
    final emotionData = jsonData as List<dynamic>;

    final emotionList = emotionData.map((data) {
      final slug = data['slug'];
      final name = data['name'];
      final moodId = data['mood'];
      return MasterFeeling(moodId: moodId, name: name, slug: slug);
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
      print('${emotion.name}: ${emotion.moodId}');
    }
  } else {
    print('Emotion list is empty or could not be loaded.');
  }
}
