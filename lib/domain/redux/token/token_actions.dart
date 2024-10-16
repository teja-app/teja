import 'package:flutter/material.dart';

@immutable
class FetchTokenSummaryAction {
  const FetchTokenSummaryAction();
}

@immutable
class TokenSummaryReceivedAction {
  final int total;
  final int used;
  final int pending;
  final int usedToday;

  const TokenSummaryReceivedAction(this.total, this.used, this.pending, this.usedToday);
}

@immutable
class TokenSummaryFailedAction {
  final String error;

  const TokenSummaryFailedAction(this.error);
}
