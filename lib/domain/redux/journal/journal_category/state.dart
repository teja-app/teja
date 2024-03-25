// lib/domain/redux/journal/journal_category/state.dart
import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';

@immutable
class JournalCategoryState {
  final List<JournalCategoryEntity> categories;
  final Map<String, JournalCategoryEntity> categoriesById;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdatedAt;
  final bool isFetchSuccessful;

  const JournalCategoryState({
    required this.categories,
    required this.categoriesById,
    this.isLoading = false,
    this.isFetchSuccessful = false,
    this.errorMessage,
    this.lastUpdatedAt,
  });

  factory JournalCategoryState.initial() {
    return const JournalCategoryState(
      categories: [],
      categoriesById: {},
    );
  }

  JournalCategoryState copyWith({
    List<JournalCategoryEntity>? categories,
    Map<String, JournalCategoryEntity>? categoriesById,
    bool? isLoading,
    String? updateErrorMessage,
    String? errorMessage,
    bool? isFetchSuccessful,
    DateTime? lastUpdatedAt,
  }) {
    return JournalCategoryState(
      categories: categories ?? this.categories,
      categoriesById: categoriesById ?? this.categoriesById,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: updateErrorMessage == null ? this.errorMessage : errorMessage,
      isFetchSuccessful: isFetchSuccessful ?? this.isFetchSuccessful,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
