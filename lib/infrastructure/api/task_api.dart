import 'package:dio/dio.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/shared/helpers/logger.dart';

class TaskApiService {
  final ApiHelper _apiHelper = ApiHelper();

  static const int CHUNK_SIZE = 10;
  static const int MAX_RETRIES = 3;

  Future<List<TaskEntity>> getAllTasks({bool includeDeleted = false}) async {
    logger.d('Fetching all tasks. includeDeleted: $includeDeleted');
    try {
      final response = await _apiHelper.get('/tasks', queryParameters: {
        'includeDeleted': includeDeleted,
      });
      logger.i('Successfully fetched ${response.data.length} tasks');
      return (response.data as List)
          .map((json) => TaskEntity.fromJson(json))
          .toList();
    } catch (e) {
      logger.e('Failed to fetch tasks', error: e);
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  Future<Map<String, dynamic>> syncTasks(List<TaskEntity> localTasks,
      DateTime lastSyncTimestamp, List<String>? previousFailedChunks) async {
    logger.d(
        'Starting task sync. Local tasks: ${localTasks.length}, Last sync: $lastSyncTimestamp, Previous failed chunks: $previousFailedChunks');
    logger.d('Previous failed chunks: $previousFailedChunks');

    const String url = '/tasks/sync';

    final tasksToSync = localTasks
        .where((task) =>
            task.updatedAt.isAfter(lastSyncTimestamp) ||
            task.updatedAt.isAtSameMomentAs(lastSyncTimestamp))
        .toList();

    logger.i('Tasks to sync: ${tasksToSync.length}');

    List<TaskEntity> allServerChanges = [];
    List<TaskEntity> allClientChanges = [];
    List<String> failedChunks = [];

    int startIndex = 0;
    if (previousFailedChunks != null && previousFailedChunks.isNotEmpty) {
      startIndex = int.parse(previousFailedChunks[0].split('-')[0]);
      logger.i('Resuming sync from index: $startIndex');
    }
    DateTime lastSuccessfulSyncTimestamp = lastSyncTimestamp;
    for (var i = startIndex; i < tasksToSync.length; i += CHUNK_SIZE) {
      var end = (i + CHUNK_SIZE < tasksToSync.length)
          ? i + CHUNK_SIZE
          : tasksToSync.length;
      var chunk = tasksToSync.sublist(i, end);

      logger.d('Syncing chunk $i-$end. Chunk size: ${chunk.length}');
      logger.d('Chunk data: ${chunk.map((t) => t.toJson())}');

      try {
        var chunkResult = await _syncChunk(url, chunk, lastSyncTimestamp);
        logger.d('Chunk result: $chunkResult');
        allServerChanges.addAll(chunkResult['serverChanges']!);
        allClientChanges.addAll(chunkResult['clientChanges']!);
        logger.i(
            'Successfully synced chunk $i-$end. Server changes: ${chunkResult['serverChanges']!.length}, Client changes: ${chunkResult['clientChanges']!.length}');
        lastSuccessfulSyncTimestamp = chunk.last.updatedAt;
      } catch (e) {
        logger.e('Failed to sync chunk $i-$end', error: e);
        failedChunks.add('$i-$end');
        break;
      }
    }

    logger.i(
        'Sync completed. Server changes: ${allServerChanges.length}, Client changes: ${allClientChanges.length}, Failed chunks: ${failedChunks.length}');

    return {
      'serverChanges': allServerChanges,
      'clientChanges': allClientChanges,
      'failedChunks': failedChunks,
      'lastSuccessfulIndex': failedChunks.isEmpty
          ? tasksToSync.length
          : int.parse(failedChunks[0].split('-')[0]) - 1,
      'lastSuccessfulSyncTimestamp': lastSuccessfulSyncTimestamp,
    };
  }

  Future<Map<String, List<TaskEntity>>> _syncChunk(
      String url, List<TaskEntity> chunk, DateTime lastSyncTimestamp) async {
    int retries = 0;
    while (retries < MAX_RETRIES) {
      try {
        logger.d('Attempting to sync chunk. Retry: $retries');
        logger.d('Chunk data: ${chunk.map((t) => t.toJson())}');
        logger.d('Last sync timestamp: $lastSyncTimestamp');

        Response response = await _apiHelper.post(url, data: {
          'entries': chunk.map((e) => e.toJson()).toList(),
          'lastSyncTimestamp': lastSyncTimestamp.millisecondsSinceEpoch,
        });

        logger.d('Response status: ${response.statusCode}');
        logger.d('Response data: ${response.data}');

        if (response.data is! Map<String, dynamic>) {
          logger.w('Unexpected response format: ${response.data.runtimeType}');
          throw Exception('Unexpected response format');
        }

        final Map<String, dynamic> responseData = response.data;

        logger.i('Chunk sync successful');
        return {
          'serverChanges': (responseData['serverChanges'] as List?)
                  ?.where((item) => item != null)
                  .map((json) =>
                      TaskEntity.fromJson(json as Map<String, dynamic>))
                  .toList() ??
              [],
          'clientChanges': (responseData['clientChanges'] as List?)
                  ?.where((item) => item != null)
                  .map((json) =>
                      TaskEntity.fromJson(json as Map<String, dynamic>))
                  .toList() ??
              [],
        };
      } catch (e) {
        retries++;
        logger.w('Chunk sync failed. Retry: $retries', error: e);
        if (retries >= MAX_RETRIES) {
          logger.e('Failed to sync chunk after $MAX_RETRIES attempts',
              error: e);
          throw Exception(
              'Failed to sync chunk after $MAX_RETRIES attempts: $e');
        }
        await Future.delayed(Duration(seconds: 2 * retries));
      }
    }
    logger.e('Unexpected error in _syncChunk');
    throw Exception('Unexpected error in _syncChunk');
  }
}
