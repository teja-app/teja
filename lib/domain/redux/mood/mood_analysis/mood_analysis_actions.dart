import 'package:flutter/foundation.dart';

@immutable
class AnalyzeMoodAction {
  final String moodEntryId;

  const AnalyzeMoodAction(this.moodEntryId);
}

@immutable
class AnalyzeMoodSuccessAction {
  final String moodEntryId;
  final Map<String, dynamic> analysisResult;

  const AnalyzeMoodSuccessAction(this.moodEntryId, this.analysisResult);
}

@immutable
class AnalyzeMoodErrorAction {
  final String errorMessage;

  const AnalyzeMoodErrorAction(this.errorMessage);
}
