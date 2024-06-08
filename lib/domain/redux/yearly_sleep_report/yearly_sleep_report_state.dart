import 'package:flutter/material.dart';
import 'package:teja/domain/redux/constants/checklist_strings.dart';

@immutable
class YearlySleepReportState {
  final bool isLoading;
  final Map<DateTime, int> yearlySleepData;
  final List<Map<String, bool>> checklist;
  final String? errorMessage;

  const YearlySleepReportState({
    this.isLoading = false,
    this.yearlySleepData = const {},
    this.errorMessage,
    this.checklist = const [
      {SLEEP_DATA: false},
    ],
  });

  factory YearlySleepReportState.initial() {
    return const YearlySleepReportState(
      isLoading: false,
      yearlySleepData: {},
      errorMessage: null,
      checklist: [
        {SLEEP_DATA: false},
      ],
    );
  }

  YearlySleepReportState copyWith({
    bool? isLoading,
    Map<DateTime, int>? yearlySleepData,
    String? errorMessage,
    List<Map<String, bool>>? checklist,
  }) {
    return YearlySleepReportState(
      isLoading: isLoading ?? this.isLoading,
      yearlySleepData: yearlySleepData ?? this.yearlySleepData,
      errorMessage: errorMessage ?? this.errorMessage,
      checklist: checklist ?? this.checklist,
    );
  }
}
