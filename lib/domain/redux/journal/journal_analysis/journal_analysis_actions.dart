import 'package:flutter/foundation.dart';

@immutable
class AnalyzeJournalAction {
  final String journalEntryId;
  final List<Map<String, String>> qaList;

  const AnalyzeJournalAction(this.journalEntryId, this.qaList);
}

@immutable
class AnalyzeJournalSuccessAction {
  final String journalEntryId;
  final Map<String, dynamic> analysisResult;

  const AnalyzeJournalSuccessAction(this.journalEntryId, this.analysisResult);
}

@immutable
class AnalyzeJournalErrorAction {
  final String errorMessage;

  const AnalyzeJournalErrorAction(this.errorMessage);
}
