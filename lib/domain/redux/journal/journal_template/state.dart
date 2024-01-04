import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';

@immutable
class JournalTemplateState {
  final List<JournalTemplateEntity> templates;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;
  final bool isFetchSuccessful;

  const JournalTemplateState({
    required this.templates,
    this.isLoading = false,
    this.isFetchSuccessful = false,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  factory JournalTemplateState.initial() {
    return const JournalTemplateState(templates: []);
  }

  JournalTemplateState copyWith({
    List<JournalTemplateEntity>? templates,
    bool? isLoading,
    String? updateErrorMessage, // New parameter to indicate if error message should be updated
    String? errorMessage,
    bool? isFetchSuccessful,
    DateTime? lastUpdatedAt,
  }) {
    return JournalTemplateState(
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: updateErrorMessage == null ? this.errorMessage : errorMessage,
      isFetchSuccessful: isFetchSuccessful ?? this.isFetchSuccessful,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
