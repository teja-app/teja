import 'package:flutter/material.dart';

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
      {"Sleep data exists": false},
    ],
  });

  factory YearlySleepReportState.initial() {
    return const YearlySleepReportState(
      isLoading: false,
      yearlySleepData: {},
      errorMessage: null,
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
