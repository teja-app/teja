import 'package:flutter/material.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';

@immutable
class FeaturedJournalTemplateState {
  final List<FeaturedJournalTemplateEntity> templates;
  final Map<String, FeaturedJournalTemplateEntity> templatesById;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;
  final bool isFetchSuccessful;

  const FeaturedJournalTemplateState({
    required this.templates,
    required this.templatesById,
    this.isLoading = false,
    this.isFetchSuccessful = false,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  factory FeaturedJournalTemplateState.initial() {
    return const FeaturedJournalTemplateState(
      templates: [],
      templatesById: {},
    );
  }

  FeaturedJournalTemplateState copyWith({
    List<FeaturedJournalTemplateEntity>? templates,
    Map<String, FeaturedJournalTemplateEntity>? templatesById,
    bool? isLoading,
    String? updateErrorMessage, // New parameter to indicate if error message should be updated
    String? errorMessage,
    bool? isFetchSuccessful,
    DateTime? lastUpdatedAt,
  }) {
    return FeaturedJournalTemplateState(
      templates: templates ?? this.templates,
      templatesById: templatesById ?? this.templatesById,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: updateErrorMessage == null ? this.errorMessage : errorMessage,
      isFetchSuccessful: isFetchSuccessful ?? this.isFetchSuccessful,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
