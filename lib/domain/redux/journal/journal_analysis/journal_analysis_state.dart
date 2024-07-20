import 'package:flutter/foundation.dart';

@immutable
class JournalAnalysisState {
  final bool isAnalyzing;
  final String? errorMessage;

  const JournalAnalysisState({
    this.isAnalyzing = false,
    this.errorMessage,
  });

  JournalAnalysisState copyWith({
    bool? isAnalyzing,
    String? errorMessage,
  }) {
    return JournalAnalysisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory JournalAnalysisState.initialState() => const JournalAnalysisState();
}
