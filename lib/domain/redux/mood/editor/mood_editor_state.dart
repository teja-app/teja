import 'package:flutter/material.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/entities/mood_log.dart';

@immutable
class MoodEditorState {
  final MoodLogEntity? currentMoodLog;
  final List<MasterFeelingEntity>? selectedFeelings;
  final int currentPageIndex;
  final bool isSubmitting;
  final String? errorMessage;
  final bool submissionSuccess;
  final Map<int, List<SubCategoryEntity?>>? selectedFactorsForFeelings;

  const MoodEditorState({
    this.currentMoodLog,
    this.currentPageIndex = 0,
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.selectedFactorsForFeelings,
    this.errorMessage,
    this.selectedFeelings,
  });

  MoodEditorState copyWith({
    MoodLogEntity? currentMoodLog,
    int? currentPageIndex,
    bool? isSubmitting,
    String? errorMessage,
    bool? submissionSuccess,
    Map<int, List<int>>? feelingFactorLink,
    List<MasterFeelingEntity>? selectedFeelings,
    Map<int, List<SubCategoryEntity?>>? selectedFactorsForFeelings,
  }) {
    return MoodEditorState(
      currentMoodLog: currentMoodLog ?? this.currentMoodLog,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      selectedFeelings: selectedFeelings ?? this.selectedFeelings,
      selectedFactorsForFeelings: selectedFactorsForFeelings ?? this.selectedFactorsForFeelings,
    );
  }

  factory MoodEditorState.initialState() => const MoodEditorState();
}
