import 'package:dio/dio.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/infrastructure/api_helper.dart';

class MoodLogApiService {
  final ApiHelper _apiHelper = ApiHelper();

  static const int CHUNK_SIZE = 10;
  static const int MAX_RETRIES = 3;

  Future<List<MoodLogEntity>> getAllEntries({bool includeDeleted = false}) async {
    try {
      final response = await _apiHelper.get('/mood-logs', queryParameters: {
        'includeDeleted': includeDeleted,
      });
      return (response.data as List).map((json) => MoodLogEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch mood logs: $e');
    }
  }

  Future<Map<String, dynamic>> syncEntries(
      List<MoodLogEntity> localEntries, DateTime lastSyncTimestamp, List<String>? previousFailedChunks) async {
    const String url = '/mood-logs/sync';

    final entriesToSync = localEntries
        .where((entry) =>
            entry.updatedAt.isAfter(lastSyncTimestamp) || entry.updatedAt.isAtSameMomentAs(lastSyncTimestamp))
        .toList();

    List<MoodLogEntity> allServerChanges = [];
    List<MoodLogEntity> allClientChanges = [];
    List<String> failedChunks = [];

    int startIndex = 0;
    if (previousFailedChunks != null && previousFailedChunks.isNotEmpty) {
      startIndex = int.parse(previousFailedChunks[0].split('-')[0]);
    }

    for (var i = startIndex; i < entriesToSync.length; i += CHUNK_SIZE) {
      var end = (i + CHUNK_SIZE < entriesToSync.length) ? i + CHUNK_SIZE : entriesToSync.length;
      var chunk = entriesToSync.sublist(i, end);

      try {
        var chunkResult = await _syncChunk(url, chunk, lastSyncTimestamp);
        allServerChanges.addAll(chunkResult['serverChanges']!);
        allClientChanges.addAll(chunkResult['clientChanges']!);
      } catch (e) {
        print('Failed to sync chunk $i-$end: $e');
        failedChunks.add('$i-$end');
        break; // Stop at the first failed chunk
      }
    }

    return {
      'serverChanges': allServerChanges,
      'clientChanges': allClientChanges,
      'failedChunks': failedChunks,
      'lastSuccessfulIndex': failedChunks.isEmpty ? entriesToSync.length : int.parse(failedChunks[0].split('-')[0]) - 1,
    };
  }

  Future<Map<String, List<MoodLogEntity>>> _syncChunk(
      String url, List<MoodLogEntity> chunk, DateTime lastSyncTimestamp) async {
    int retries = 0;
    while (retries < MAX_RETRIES) {
      try {
        Response response = await _apiHelper.post(url, data: {
          'entries': chunk.map((e) => e.toJson()).toList(),
          'lastSyncTimestamp': lastSyncTimestamp.millisecondsSinceEpoch,
        });

        if (response.data is! Map<String, dynamic>) {
          throw Exception('Unexpected response format');
        }

        final Map<String, dynamic> responseData = response.data;

        return {
          'serverChanges': (responseData['serverChanges'] as List?)
                  ?.map((json) => MoodLogEntity.fromJson(json as Map<String, dynamic>))
                  .toList() ??
              [],
          'clientChanges': (responseData['clientChanges'] as List?)
                  ?.map((json) => MoodLogEntity.fromJson(json as Map<String, dynamic>))
                  .toList() ??
              [],
        };
      } catch (e) {
        retries++;
        if (retries >= MAX_RETRIES) {
          throw Exception('Failed to sync chunk after $MAX_RETRIES attempts: $e');
        }
        await Future.delayed(Duration(seconds: 2 * retries)); // Exponential backoff
      }
    }
    throw Exception('Unexpected error in _syncChunk');
  }
}
