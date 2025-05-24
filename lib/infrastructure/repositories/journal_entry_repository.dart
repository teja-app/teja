import 'package:cbl/cbl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart' as cbl;
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/repositories/journal_entry_cbl_helpers.dart';

/// Repository for managing journal entries using Couchbase Lite
class JournalEntryRepository {
  final Database database;
  static const String LAST_SYNC_KEY = 'last_journal_sync_timestamp';

  JournalEntryRepository(this.database);

  /// Get a journal entry by its ID
  ///
  /// [id] The ID of the journal entry to retrieve
  /// Returns the journal entry or null if not found
  Future<cbl.JournalEntry?> getJournalEntryById(String? id) async {
    if (id == null) return null;

    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(id);
      if (doc == null) return null;

      return cbl.ImmutableJournalEntry.internal(doc);
    } catch (e) {
      print('Error getting journal entry by ID: $e');
      return null;
    }
  }

  /// Get all journal entries
  ///
  /// [includeDeleted] Whether to include soft-deleted entries
  /// Returns a list of journal entries
  Future<List<JournalEntryEntity>> getAllJournalEntries({bool includeDeleted = false}) async {
    try {
      final collection = await database.defaultCollection;

      // Build the query - explicitly select document ID and all properties
      var queryBuilder = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection));

      // Add where clause if needed
      Query query;
      if (!includeDeleted) {
        query = queryBuilder.where(Expression.property('isDeleted').equalTo(Expression.boolean(false)));
      } else {
        query = queryBuilder;
      }

      final resultSet = await query.execute();
      final entries = <JournalEntryEntity>[];

      await for (final result in resultSet.asStream()) {
        // Get the document ID (first selected item)
        final docId = result.string(0);

        // Get the dictionary (document content - second selected item)
        final dictionary = result.dictionary(1);

        if (docId != null && dictionary != null) {
          // Convert to plain map
          final map = dictionary.toPlainMap();

          // Add the document ID to the map
          map['id'] = docId;

          // Convert the plain map to a JournalEntryEntity
          entries.add(JournalEntryEntity.fromJson(map));
        } else {
          print('Warning: Invalid document data, docId: $docId, dictionary: ${dictionary != null}');
        }
      }

      return entries;
    } catch (e) {
      print('Error getting all journal entries: $e');
      return [];
    }
  }

  /// Add or update a journal entry
  ///
  /// [journalEntry] The journal entry to save
  Future<void> addOrUpdateJournalEntry(cbl.JournalEntry journalEntry) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;

        // Create a mutable document with the journal entry ID
        final doc = MutableDocument.withId(journalEntry.id ?? '');

        // Create a dictionary with all the journal entry data
        final data = {
          'templateId': journalEntry.templateId,
          'timestamp': (journalEntry.timestamp ?? DateTime.now()).toIso8601String(),
          'createdAt': (journalEntry.createdAt ?? DateTime.now()).toIso8601String(),
          'updatedAt': (journalEntry.updatedAt ?? DateTime.now()).toIso8601String(),
          'lock': journalEntry.lock,
          'emoticon': journalEntry.emoticon,
          'title': journalEntry.title,
          'body': journalEntry.body,
          'summary': journalEntry.summary,
          'keyInsight': journalEntry.keyInsight,
          'affirmation': journalEntry.affirmation,
          'topics': journalEntry.topics,
          'isDeleted': journalEntry.isDeleted,
          // Add other properties as needed
        };

        // Set the data on the document
        doc.setData(data);

        // Save the document
        await collection.saveDocument(doc);
      });
    } catch (e) {
      print('Error adding or updating journal entry: $e');
      throw Exception('Failed to save journal entry: $e');
    }
  }

  /// Soft delete a journal entry
  ///
  /// [id] The ID of the journal entry to soft delete
  Future<void> softDeleteJournalEntry(String id) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        final doc = await collection.document(id);

        if (doc != null) {
          // Create a mutable document with the same ID
          final mutableDoc = MutableDocument.withId(id);

          // Get all existing data from the document
          final existingData = doc.toPlainMap();

          // Update the necessary fields
          existingData['isDeleted'] = true;
          existingData['updatedAt'] = DateTime.now().toIso8601String();

          // Set all data at once
          mutableDoc.setData(existingData);

          // Save the document
          await collection.saveDocument(mutableDoc);
        }
      });
    } catch (e) {
      print('Error soft deleting journal entry: $e');
      throw Exception('Failed to soft delete journal entry: $e');
    }
  }

  /// Add or update multiple journal entries
  ///
  /// [entries] The list of journal entries to save
  Future<void> addOrUpdateJournalEntries(List<JournalEntryEntity> entries) async {
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;

        for (var entry in entries) {
          // Convert entity to journal entry
          final journalEntry = fromEntityCBL(entry);

          // Check if an entry with this ID already exists
          final existingDoc = await collection.document(journalEntry.id ?? '');

          if (existingDoc != null) {
            // If it exists, update it only if the new entry is more recent
            final existingUpdatedAtStr = existingDoc.string('updatedAt');
            if (existingUpdatedAtStr != null) {
              final existingUpdatedAt = DateTime.parse(existingUpdatedAtStr);

              if (journalEntry.updatedAt.isAfter(existingUpdatedAt)) {
                // Create a mutable document with the ID
                final doc = MutableDocument.withId(journalEntry.id ?? '');

                // Create a dictionary with all the journal entry data
                final data = {
                  'templateId': journalEntry.templateId,
                  'timestamp': journalEntry.timestamp.toIso8601String(),
                  'createdAt': journalEntry.createdAt.toIso8601String(),
                  'updatedAt': journalEntry.updatedAt.toIso8601String(),
                  'lock': journalEntry.lock,
                  'emoticon': journalEntry.emoticon,
                  'title': journalEntry.title,
                  'body': journalEntry.body,
                  'summary': journalEntry.summary,
                  'keyInsight': journalEntry.keyInsight,
                  'affirmation': journalEntry.affirmation,
                  'topics': journalEntry.topics,
                  'isDeleted': journalEntry.isDeleted,
                  // Add other properties as needed
                };

                // Set the data on the document
                doc.setData(data);

                // Save the document
                await collection.saveDocument(doc);
              }
            } else {
              // If updatedAt is missing in the existing document, update it
              final doc = MutableDocument.withId(journalEntry.id ?? '');

              // Create a dictionary with all the journal entry data
              final data = {
                'templateId': journalEntry.templateId,
                'timestamp': journalEntry.timestamp.toIso8601String(),
                'createdAt': journalEntry.createdAt.toIso8601String(),
                'updatedAt': journalEntry.updatedAt.toIso8601String(),
                'lock': journalEntry.lock,
                'emoticon': journalEntry.emoticon,
                'title': journalEntry.title,
                'body': journalEntry.body,
                'summary': journalEntry.summary,
                'keyInsight': journalEntry.keyInsight,
                'affirmation': journalEntry.affirmation,
                'topics': journalEntry.topics,
                'isDeleted': journalEntry.isDeleted,
                // Add other properties as needed
              };

              // Set the data on the document
              doc.setData(data);

              // Save the document
              await collection.saveDocument(doc);
            }
          } else {
            // If it doesn't exist, add it as a new entry
            final doc = MutableDocument.withId(journalEntry.id ?? '');

            // Create a dictionary with all the journal entry data
            final data = {
              'templateId': journalEntry.templateId,
              'timestamp': journalEntry.timestamp.toIso8601String(),
              'createdAt': journalEntry.createdAt.toIso8601String(),
              'updatedAt': journalEntry.updatedAt.toIso8601String(),
              'lock': journalEntry.lock,
              'emoticon': journalEntry.emoticon,
              'title': journalEntry.title,
              'body': journalEntry.body,
              'summary': journalEntry.summary,
              'keyInsight': journalEntry.keyInsight,
              'affirmation': journalEntry.affirmation,
              'topics': journalEntry.topics,
              'isDeleted': journalEntry.isDeleted,
              // Add other properties as needed
            };

            // Set the data on the document
            doc.setData(data);

            // Save the document
            await collection.saveDocument(doc);
          }
        }
      });
    } catch (e) {
      print('Error adding or updating journal entries: $e');
      throw Exception('Failed to save journal entries: $e');
    }
  }

  /// Permanently delete a journal entry
  ///
  /// [id] The ID of the journal entry to delete
  Future<void> deleteJournalEntryById(String? id) async {
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
      print('Error deleting journal entry: $e');
      throw Exception('Failed to delete journal entry: $e');
    }
  }

  /// Get a page of journal entries
  ///
  /// [pageKey] The page number (0-based)
  /// [pageSize] The number of entries per page
  /// [startDate] Optional start date filter
  /// [endDate] Optional end date filter
  /// [includeDeleted] Whether to include soft-deleted entries
  /// Returns a list of journal entries for the requested page
  Future<List<JournalEntryEntity>> getJournalEntriesPage(
    int pageKey,
    int pageSize, {
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) async {
    try {
      final collection = await database.defaultCollection;
      // Select document ID and all properties
      var query = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection));

      // Build query conditions
      var whereExpr = Expression.property('isDeleted').equalTo(Expression.boolean(includeDeleted));

      if (startDate != null) {
        whereExpr = whereExpr
            .and(Expression.property('timestamp').greaterThanOrEqualTo(Expression.string(startDate.toIso8601String())));
      }

      if (endDate != null) {
        whereExpr = whereExpr
            .and(Expression.property('timestamp').lessThanOrEqualTo(Expression.string(endDate.toIso8601String())));
      }

      // Apply where clause
      final queryWithWhere = query.where(whereExpr);

      // Apply ordering
      final queryWithOrder = queryWithWhere.orderBy(Ordering.property('timestamp').descending());

      // Apply limit and offset
      final finalQuery = queryWithOrder.limit(Expression.integer(pageSize), offset: Expression.integer(pageKey));

      // Execute the query
      final result = await finalQuery.execute();

      final journalEntries = <JournalEntryEntity>[];

      await for (final results in result.asStream()) {
        // Get the document ID (first selected item)
        final docId = results.string(0);
        if (docId == null) continue; // Skip if ID is somehow null

        // Get the dictionary (document content - second selected item)
        final dictionary = results.dictionary(1);
        if (dictionary != null) {
          // Convert to plain map
          final map = dictionary.toPlainMap();
          // Add the document ID to the map
          map['id'] = docId;
          print("$docId ${dictionary.toString()}");
          // Convert the map directly to a JournalEntryEntity
          journalEntries.add(JournalEntryEntity.fromJson(map));
        }
      }

      return journalEntries;
    } catch (e) {
      print('Error getting journal entries page: $e');
      return [];
    }
  }

  /// Get journal entries within a date range
  ///
  /// [start] The start date
  /// [end] The end date
  /// [includeDeleted] Whether to include soft-deleted entries
  /// Returns a list of journal entries within the date range
  Future<List<JournalEntryEntity>> getJournalEntriesInDateRange(
    DateTime start,
    DateTime end, {
    bool includeDeleted = false,
  }) async {
    try {
      final collection = await database.defaultCollection;
      final query = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection))
          .where(Expression.property('timestamp')
              .greaterThanOrEqualTo(Expression.string(start.toIso8601String()))
              .and(Expression.property('timestamp').lessThanOrEqualTo(Expression.string(end.toIso8601String())))
              .and(includeDeleted
                  ? Expression.boolean(true)
                  : Expression.property('isDeleted').equalTo(Expression.boolean(false))))
          .orderBy(Ordering.property('timestamp').descending());

      final result = await query.execute();
      final journalEntries = <JournalEntryEntity>[];

      await for (final results in result.asStream()) {
        // Get the document ID (first selected item)
        final docId = results.string(0);

        // Get the dictionary (document content - second selected item)
        final dictionary = results.dictionary(1);

        if (docId != null && dictionary != null) {
          // Convert to plain map
          final map = dictionary.toPlainMap();

          // Add the document ID to the map
          map['id'] = docId;

          // Convert the map directly to a JournalEntryEntity
          journalEntries.add(JournalEntryEntity.fromJson(map));
        } else {
          print('Warning: Invalid document data in date range query, docId: $docId, dictionary: ${dictionary != null}');
        }
      }

      return journalEntries;
    } catch (e) {
      print('Error getting journal entries in date range: $e');
      return [];
    }
  }

  /// Convert a JournalEntry to a JournalEntryEntity
  JournalEntryEntity toEntity(cbl.JournalEntry journalEntry) {
    return toEntityCBL(journalEntry);
  }

  /// Update the last sync timestamp
  ///
  /// [timestamp] The timestamp to save
  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LAST_SYNC_KEY, timestamp.toIso8601String());
  }

  /// Get the last sync timestamp
  ///
  /// Returns the last sync timestamp or null if not set
  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestampString = prefs.getString(LAST_SYNC_KEY);
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }
}
