import 'package:flutter/foundation.dart';

@immutable
class MoodAnalysisState {
  final bool isAnalyzing;
  final String? errorMessage;

  const MoodAnalysisState({
    this.isAnalyzing = false,
    this.errorMessage,
  });

  MoodAnalysisState copyWith({
    bool? isAnalyzing,
    String? errorMessage,
  }) {
    return MoodAnalysisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory MoodAnalysisState.initialState() => const MoodAnalysisState();
}
