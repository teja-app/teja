// lib/infrastructure/repositories/mood_log_repository.dart
// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:cbl/cbl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/mood/list/state.dart';
import 'package:teja/infrastructure/database/cbl_collections/mood_log.dart' as cbl;

class MoodLogRepository {
  final Database database;

  MoodLogRepository(this.database);
  static const String LAST_SYNC_KEY = 'last_mood_sync_timestamp';
  static const String FAILED_CHUNKS_KEY = 'failed_mood_chunks';

  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_SYNC_KEY, timestamp.toIso8601String());
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestampString = prefs.getString(LAST_SYNC_KEY);
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }

  Future<List<String>?> getPreviousFailedChunks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(FAILED_CHUNKS_KEY);
  }

  Future<void> storeFailedChunks(List<String> failedChunks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(FAILED_CHUNKS_KEY, failedChunks);
  }

  Future<void> clearFailedChunks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(FAILED_CHUNKS_KEY);
  }

  Future<void> addOrUpdateMoodLogs(List<MoodLogEntity> moodLogs) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        
        for (var moodLogEntity in moodLogs) {
          // Check if a mood log with this ID already exists
          final existingDoc = await collection.document(moodLogEntity.id);
          
          if (existingDoc != null) {
            // If it exists, update it only if the new entry is more recent
            final existingUpdatedAtStr = existingDoc.string('updatedAt');
            if (existingUpdatedAtStr != null) {
              final existingUpdatedAt = DateTime.parse(existingUpdatedAtStr);
              
              if (DateTime.now().isAfter(existingUpdatedAt)) {
                await _saveMoodLog(collection, moodLogEntity);
              }
            }
          } else {
            // If it doesn't exist, add it as a new entry
            await _saveMoodLog(collection, moodLogEntity);
          }
        }
      });
    } catch (e) {
      print('Error adding or updating mood logs: $e');
      throw Exception('Failed to save mood logs: $e');
    }
  }

  Future<void> _saveMoodLog(Collection collection, MoodLogEntity moodLogEntity) async {
    final doc = MutableDocument.withId(moodLogEntity.id);
    
    final data = {
      'timestamp': moodLogEntity.timestamp.toIso8601String(),
      'createdAt': moodLogEntity.createdAt.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'moodRating': moodLogEntity.moodRating,
      'comment': moodLogEntity.comment,
      'senderId': moodLogEntity.senderId,
      'feelings': moodLogEntity.feelings
          ?.map((f) => {
                'feeling': f.feeling,
                'comment': f.comment,
                'factors': f.factors,
                'detailed': f.detailed,
              })
          .toList(),
      'factors': moodLogEntity.factors,
      'attachments': moodLogEntity.attachments
          ?.map((a) => {
                'id': a.id,
                'type': a.type,
                'path': a.path,
              })
          .toList(),
      'ai': moodLogEntity.ai != null
          ? {
              'suggestion': moodLogEntity.ai!.suggestion,
              'title': moodLogEntity.ai!.title,
              'affirmation': moodLogEntity.ai!.affirmation,
            }
          : null,
      'isDeleted': moodLogEntity.isDeleted,
    };
    
    doc.setData(data);
    await collection.saveDocument(doc);
  }

  Future<void> softDeleteMoodLog(String id) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(id);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(id);
          final existingData = doc.toPlainMap();
          
          existingData['isDeleted'] = true;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error soft deleting mood log: $e');
      throw Exception('Failed to soft delete mood log: $e');
    }
  }

  Future<cbl.MoodLog?> getMoodLogById(String? id) async {
    if (id == null) return null;
    
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(id);
      if (doc == null) return null;
      
      return cbl.ImmutableMoodLog.internal(doc);
    } catch (e) {
      print('Error getting mood log by ID: $e');
      return null;
    }
  }

  Future<List<MoodLogEntity>> getAllMoodLogs({bool includeDeleted = false}) async {
    try {
      final collection = await database.defaultCollection;
      
      var queryBuilder = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection));
      
      Query query;
      if (!includeDeleted) {
        query = queryBuilder.where(Expression.property('isDeleted').equalTo(Expression.boolean(false)));
      } else {
        query = queryBuilder;
      }
      
      final resultSet = await query.execute();
      final entries = <MoodLogEntity>[];
      
      await for (final result in resultSet.asStream()) {
        final docId = result.string(0);
        final dictionary = result.dictionary(1);
        
        if (docId != null && dictionary != null) {
          final map = dictionary.toPlainMap();
          map['id'] = docId;
          
          entries.add(_mapToEntity(map));
        }
      }
      
      return entries;
    } catch (e) {
      print('Error getting all mood logs: $e');
      return [];
    }
  }

  Future<List<MoodLogEntity>> getMoodLogsPage(int pageKey, int pageSize, [MoodLogFilter? filter]) async {
    try {
      final collection = await database.defaultCollection;
      final startIndex = pageKey * pageSize;
      
      var queryBuilder = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection));
      
      // Add filter conditions
      Expression? whereExpression;
      if (filter != null && filter.selectedMoodRatings.isNotEmpty) {
        var moodRatingExpressions = filter.selectedMoodRatings
            .map((rating) => Expression.property('moodRating').equalTo(Expression.integer(rating)))
            .toList();
        
        whereExpression = moodRatingExpressions.reduce((value, element) => value.or(element));
      }
      
      if (whereExpression != null) {
        queryBuilder = queryBuilder.where(whereExpression);
      }
      
      // Add ordering and pagination
      final query = queryBuilder
          .orderBy(Ordering.property('timestamp').descending())
          .limit(Expression.integer(pageSize), offset: Expression.integer(startIndex));
      
      final resultSet = await query.execute();
      final entries = <MoodLogEntity>[];
      
      await for (final result in resultSet.asStream()) {
        final docId = result.string(0);
        final dictionary = result.dictionary(1);
        
        if (docId != null && dictionary != null) {
          final map = dictionary.toPlainMap();
          map['id'] = docId;
          
          entries.add(_mapToEntity(map));
        }
      }
      
      return entries;
    } catch (e) {
      print('Error getting mood logs page: $e');
      return [];
    }
  }

  Future<void> addAttachmentToMoodLog(String moodLogId, MoodLogAttachmentEntity attachmentEntity) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          final attachments = List<Map<String, dynamic>>.from(existingData['attachments'] ?? []);
          attachments.add({
            'id': attachmentEntity.id,
            'type': attachmentEntity.type,
            'path': attachmentEntity.path,
          });
          
          existingData['attachments'] = attachments;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error adding attachment to mood log: $e');
      throw Exception('Failed to add attachment: $e');
    }
  }

  Future<void> removeAttachmentFromMoodLog(String moodLogId, String attachmentId) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          final attachments = List<Map<String, dynamic>>.from(existingData['attachments'] ?? []);
          attachments.removeWhere((attachment) => attachment['id'] == attachmentId);
          
          existingData['attachments'] = attachments;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
          
          // Optionally, handle file deletion here if needed
          try {
            final fileToDelete = File(attachmentId);
            if (await fileToDelete.exists()) {
              await fileToDelete.delete();
            }
          } catch (e) {
            print('Error deleting attachment file: $e');
          }
        }
      });
    } catch (e) {
      print('Error removing attachment from mood log: $e');
      throw Exception('Failed to remove attachment: $e');
    }
  }

  Future<void> updateMoodLogComment(String moodLogId, String comment) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          existingData['comment'] = comment;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating mood log comment: $e');
      throw Exception('Failed to update comment: $e');
    }
  }

  Future<List<MoodLogEntity>> getMoodLogsForWeek(DateTime startDate, DateTime endDate) async {
    try {
      final collection = await database.defaultCollection;
      
      final query = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection))
          .where(
            Expression.property('timestamp')
                .greaterThanOrEqualTo(Expression.string(startDate.toIso8601String()))
                .and(Expression.property('timestamp')
                    .lessThanOrEqualTo(Expression.string(endDate.toIso8601String())))
          );
      
      final resultSet = await query.execute();
      final entries = <MoodLogEntity>[];
      
      await for (final result in resultSet.asStream()) {
        final docId = result.string(0);
        final dictionary = result.dictionary(1);
        
        if (docId != null && dictionary != null) {
          final map = dictionary.toPlainMap();
          map['id'] = docId;
          
          entries.add(_mapToEntity(map));
        }
      }
      
      return entries;
    } catch (e) {
      print('Error getting mood logs for week: $e');
      return [];
    }
  }

  Future<Map<DateTime, double>> getAverageMoodLogsForWeek(DateTime startDate, DateTime endDate) async {
    final moodLogs = await getMoodLogsForWeek(startDate, endDate);
    
    Map<DateTime, List<int>> dailyRatings = {};
    for (var log in moodLogs) {
      DateTime day = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      dailyRatings.putIfAbsent(day, () => []).add(log.moodRating);
    }
    
    Map<DateTime, double> averageRatings = {};
    dailyRatings.forEach((date, ratings) {
      averageRatings[date] = ratings.reduce((a, b) => a + b) / ratings.length;
    });
    
    return averageRatings;
  }

  Future<void> addOrUpdateMoodLog(cbl.MoodLog moodLog) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = MutableDocument.withId(moodLog.id ?? '');
        
        final data = {
          'timestamp': moodLog.timestamp.toIso8601String(),
          'createdAt': moodLog.createdAt.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'moodRating': moodLog.moodRating,
          'comment': moodLog.comment,
          'senderId': moodLog.senderId,
          'feelings': moodLog.feelings
              ?.map((f) => {
                    'feeling': f.feeling,
                    'comment': f.comment,
                    'factors': f.factors,
                    'detailed': f.detailed,
                  })
              .toList(),
          'factors': moodLog.factors,
          'attachments': moodLog.attachments
              ?.map((a) => {
                    'id': a.id,
                    'type': a.type,
                    'path': a.path,
                  })
              .toList(),
          'ai': moodLog.ai != null
              ? {
                  'suggestion': moodLog.ai!.suggestion,
                  'title': moodLog.ai!.title,
                  'affirmation': moodLog.ai!.affirmation,
                }
              : null,
          'isDeleted': moodLog.isDeleted,
        };
        
        doc.setData(data);
        await collection.saveDocument(doc);
      });
    } catch (e) {
      print('Error adding or updating mood log: $e');
      throw Exception('Failed to save mood log: $e');
    }
  }

  Future<void> deleteMoodLogById(String? id) async {
    if (id == null) return;
    
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(id);
        if (doc != null) {
          await collection.deleteDocument(doc);
        }
      });
    } catch (e) {
      print('Error deleting mood log: $e');
      throw Exception('Failed to delete mood log: $e');
    }
  }

  Future<void> updateFeelingsForMoodLog(
    String moodLogId,
    List<cbl.MoodLogFeeling> updatedFeelings,
  ) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          existingData['feelings'] = updatedFeelings
              .map((f) => {
                    'feeling': f.feeling,
                    'comment': f.comment,
                    'factors': f.factors,
                    'detailed': f.detailed,
                  })
              .toList();
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating feelings for mood log: $e');
      throw Exception('Failed to update feelings: $e');
    }
  }

  Future<void> updateBroadFactorsForMoodLog(String moodLogId, List<String> broadFactors) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          existingData['factors'] = broadFactors;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating broad factors for mood log: $e');
      throw Exception('Failed to update broad factors: $e');
    }
  }

  Future<void> updateFactorsForFeeling(String moodLogId, String feelingSlug, List<String>? factorSlugs) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          final feelings = List<Map<String, dynamic>>.from(existingData['feelings'] ?? []);
          for (var i = 0; i < feelings.length; i++) {
            if (feelings[i]['feeling'] == feelingSlug) {
              feelings[i]['factors'] = factorSlugs;
              break;
            }
          }
          
          existingData['feelings'] = feelings;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating factors for feeling: $e');
      throw Exception('Failed to update factors for feeling: $e');
    }
  }

  Future<cbl.MoodLog?> getTodaysMoodLog() async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    final moodLogs = await _getMoodLogsInDateRange(startOfDay, endOfDay);
    
    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }

  Future<List<cbl.MoodLog>> getMoodLogsInDateRange(DateTime start, DateTime end) async {
    return await _getMoodLogsInDateRange(start, end);
  }

  Future<List<cbl.MoodLog>> _getMoodLogsInDateRange(DateTime start, DateTime end) async {
    try {
      final collection = await database.defaultCollection;
      
      final query = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection))
          .where(
            Expression.property('timestamp')
                .greaterThanOrEqualTo(Expression.string(start.toIso8601String()))
                .and(Expression.property('timestamp')
                    .lessThanOrEqualTo(Expression.string(end.toIso8601String())))
          );
      
      final resultSet = await query.execute();
      final entries = <cbl.MoodLog>[];
      
      await for (final result in resultSet.asStream()) {
        final docId = result.string(0);
        
        if (docId != null) {
          final doc = await collection.document(docId);
          if (doc != null) {
            entries.add(cbl.ImmutableMoodLog.internal(doc));
          }
        }
      }
      
      return entries;
    } catch (e) {
      print('Error getting mood logs in date range: $e');
      return [];
    }
  }

  Future<cbl.MoodLog?> getMoodLogByDate(DateTime date) async {
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final moodLogs = await _getMoodLogsInDateRange(startOfDay, endOfDay);
    
    return moodLogs.isNotEmpty ? moodLogs.first : null;
  }

  Future<int> calculateCurrentStreak() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    int streakCount = 0;
    DateTime? currentDay = today;
    
    while (true) {
      final cbl.MoodLog? moodLog = await getMoodLogByDate(currentDay!);
      if (moodLog != null) {
        streakCount++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streakCount;
  }

  MoodLogEntity toEntity(cbl.MoodLog moodLog) {
    return MoodLogEntity(
      id: moodLog.id ?? '',
      timestamp: moodLog.timestamp,
      moodRating: moodLog.moodRating,
      comment: moodLog.comment,
      feelings: moodLog.feelings
          ?.map((f) => FeelingEntity(
                feeling: f.feeling ?? '',
                comment: f.comment,
                factors: f.factors,
                detailed: f.detailed,
              ))
          .toList(),
      factors: moodLog.factors,
      attachments: moodLog.attachments
          ?.map((a) => MoodLogAttachmentEntity(
                id: a.id,
                type: a.type,
                path: a.path,
              ))
          .toList(),
      ai: moodLog.ai != null
          ? MoodLogAIEntity(
              suggestion: moodLog.ai!.suggestion,
              title: moodLog.ai!.title,
              affirmation: moodLog.ai!.affirmation,
            )
          : null,
      isDeleted: moodLog.isDeleted,
      createdAt: moodLog.createdAt,
      updatedAt: moodLog.updatedAt,
      senderId: moodLog.senderId,
    );
  }

  MoodLogEntity _mapToEntity(Map<String, dynamic> map) {
    return MoodLogEntity(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      moodRating: map['moodRating'] as int,
      comment: map['comment'] as String?,
      senderId: map['senderId'] as String?,
      feelings: (map['feelings'] as List<dynamic>?)
          ?.map((f) => FeelingEntity(
                feeling: f['feeling'] as String,
                comment: f['comment'] as String?,
                factors: (f['factors'] as List<dynamic>?)?.cast<String>(),
                detailed: f['detailed'] as bool?,
              ))
          .toList(),
      factors: (map['factors'] as List<dynamic>?)?.cast<String>(),
      attachments: (map['attachments'] as List<dynamic>?)
          ?.map((a) => MoodLogAttachmentEntity(
                id: a['id'] as String,
                type: a['type'] as String,
                path: a['path'] as String,
              ))
          .toList(),
      ai: map['ai'] != null
          ? MoodLogAIEntity(
              suggestion: map['ai']['suggestion'] as String?,
              title: map['ai']['title'] as String?,
              affirmation: map['ai']['affirmation'] as String?,
            )
          : null,
      isDeleted: map['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Future<void> updateAISuggestion(String moodLogId, String suggestion) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          final aiData = (existingData['ai'] as Map<String, dynamic>?) ?? {};
          aiData['suggestion'] = suggestion;
          
          existingData['ai'] = aiData;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating AI suggestion: $e');
      throw Exception('Failed to update AI suggestion: $e');
    }
  }

  Future<String?> fetchAISuggestion(String moodLogId) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(moodLogId);
      
      if (doc != null) {
        final aiData = doc.dictionary('ai');
        return aiData?.string('suggestion');
      }
      return null;
    } catch (e) {
      print('Error fetching AI suggestion: $e');
      return null;
    }
  }

  Future<void> updateAITitle(String moodLogId, String title) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          final aiData = (existingData['ai'] as Map<String, dynamic>?) ?? {};
          aiData['title'] = title;
          
          existingData['ai'] = aiData;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating AI title: $e');
      throw Exception('Failed to update AI title: $e');
    }
  }

  Future<void> updateAIAffirmation(String moodLogId, String affirmation) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(moodLogId);
        
        if (doc != null) {
          final mutableDoc = MutableDocument.withId(moodLogId);
          final existingData = doc.toPlainMap();
          
          final aiData = (existingData['ai'] as Map<String, dynamic>?) ?? {};
          aiData['affirmation'] = affirmation;
          
          existingData['ai'] = aiData;
          existingData['updatedAt'] = DateTime.now().toIso8601String();
          
          mutableDoc.setData(existingData);
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error updating AI affirmation: $e');
      throw Exception('Failed to update AI affirmation: $e');
    }
  }

  Future<String?> fetchAITitle(String moodLogId) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(moodLogId);
      
      if (doc != null) {
        final aiData = doc.dictionary('ai');
        return aiData?.string('title');
      }
      return null;
    } catch (e) {
      print('Error fetching AI title: $e');
      return null;
    }
  }

  Future<String?> fetchAIAffirmation(String moodLogId) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(moodLogId);
      
      if (doc != null) {
        final aiData = doc.dictionary('ai');
        return aiData?.string('affirmation');
      }
      return null;
    } catch (e) {
      print('Error fetching AI affirmation: $e');
      return null;
    }
  }
}