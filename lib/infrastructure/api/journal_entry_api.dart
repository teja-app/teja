// lib/infrastructure/api/journal_entry_api_service.dart

import 'package:dio/dio.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/api_helper.dart';

class JournalEntryApiService {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<JournalEntryEntity>> getAllEntries() async {
    try {
      const String url = '/journals';
      final response = await _apiHelper.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => JournalEntryEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch journal entries');
      }
    } catch (e) {
      throw Exception('Error fetching journal entries: $e');
    }
  }

  Future<Map<String, List<JournalEntryEntity>>> syncEntries(
      List<JournalEntryEntity> localEntries, DateTime lastSyncTimestamp) async {
    const String url = '/journals/sync';

    // Filter local entries that have been updated since the last sync
    final entriesToSync = localEntries
        .where((entry) =>
            entry.updatedAt.isAfter(lastSyncTimestamp) || entry.updatedAt.isAtSameMomentAs(lastSyncTimestamp))
        .toList();

    Response response = await _apiHelper.post(url, data: {
      'entries': entriesToSync.map((e) => e.toJson()).toList(),
      'lastSyncTimestamp': lastSyncTimestamp.toIso8601String(),
    });

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Unexpected response format');
    }

    final Map<String, dynamic> responseData = response.data;

    return {
      'serverChanges': (responseData['serverChanges'] as List?)
              ?.map((json) => JournalEntryEntity.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [],
      'clientChanges': (responseData['clientChanges'] as List?)
              ?.map((json) => JournalEntryEntity.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [],
    };
  }
}
