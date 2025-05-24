import 'package:cbl/cbl.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_feeling.dart' as cbl;

class MasterFeelingRepository {
  final Database database;

  MasterFeelingRepository(this.database);

  Future<List<cbl.MasterFeeling>> getAllFeelings() async {
    try {
      final collection = await database.defaultCollection;
      
      final query = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection))
          .where(Expression.property('type').equalTo(Expression.string('feeling'))); // Filter for master feelings
      
      final resultSet = await query.execute();
      final feelings = <cbl.MasterFeeling>[];
      
      await for (final result in resultSet.asStream()) {
        final docId = result.string(0);
        
        if (docId != null) {
          final doc = await collection.document(docId);
          if (doc != null) {
            feelings.add(cbl.ImmutableMasterFeeling.internal(doc));
          }
        }
      }
      
      return feelings;
    } catch (e) {
      return [];
    }
  }

  Future<List<MasterFeelingEntity>> getAllFeelingEntities() async {
    List<cbl.MasterFeeling> feelings = await getAllFeelings();
    return feelings.map(toEntity).toList();
  }

  Future<Map<String, String>> addOrUpdateFeelings(List<cbl.MasterFeeling> feelings) async {
    Map<String, String> feelingIds = {};
    
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        
        for (var feeling in feelings) {
          // Create a unique key for the feeling
          final uniqueKey = feeling.slug + (feeling.parentSlug ?? '');
          
          // Search for existing feeling with the same slug and parentSlug
          final query = const QueryBuilder()
              .select(SelectResult.expression(Meta.id))
              .from(DataSource.collection(collection))
              .where(
                Expression.property('slug').equalTo(Expression.string(feeling.slug))
                .and(
                  feeling.parentSlug != null
                    ? Expression.property('parentSlug').equalTo(Expression.string(feeling.parentSlug!))
                    : Expression.property('parentSlug').isNullOrMissing()
                )
              );
          
          final resultSet = await query.execute();
          String? existingId;
          
          await for (final result in resultSet.asStream()) {
            existingId = result.string(0);
            break; // We only need the first match
          }
          
          final docId = existingId ?? feeling.id;
          final doc = MutableDocument.withId(docId);
          
          final data = {
            'slug': feeling.slug,
            'name': feeling.name,
            'type': feeling.type,
            'parentSlug': feeling.parentSlug,
            'energy': feeling.energy,
            'pleasantness': feeling.pleasantness,
          };
          
          doc.setData(data);
          await collection.saveDocument(doc);
          
          feelingIds[uniqueKey] = docId;
        }
      });
      
      return feelingIds;
    } catch (e) {
      throw Exception('Failed to save feelings: $e');
    }
  }

  MasterFeelingEntity toEntity(cbl.MasterFeeling feeling) {
    return MasterFeelingEntity(
      id: feeling.id,
      slug: feeling.slug,
      name: feeling.name,
      type: feeling.type,
      parentSlug: feeling.parentSlug,
      energy: feeling.energy,
      pleasantness: feeling.pleasantness,
    );
  }

  Future<String> convertIdToSlug(String id) async {
    try {
      final collection = await database.defaultCollection;
      final doc = await collection.document(id);
      
      if (doc != null) {
        return doc.string('slug') ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<Map<String, MasterFeelingEntity>> getFeelingsBySlugs(List<String?> slugs) async {
    Map<String, MasterFeelingEntity> feelingsMap = {};
    
    try {
      final collection = await database.defaultCollection;
      
      for (var slug in slugs) {
        if (slug != null) {
          final query = const QueryBuilder()
              .select(SelectResult.expression(Meta.id), SelectResult.all())
              .from(DataSource.collection(collection))
              .where(Expression.property('slug').equalTo(Expression.string(slug)));
          
          final resultSet = await query.execute();
          
          await for (final result in resultSet.asStream()) {
            final docId = result.string(0);
            
            if (docId != null) {
              final doc = await collection.document(docId);
              if (doc != null) {
                final feeling = cbl.ImmutableMasterFeeling.internal(doc);
                feelingsMap[slug] = toEntity(feeling);
                break; // We only need the first match
              }
            }
          }
        }
      }
      
      return feelingsMap;
    } catch (e) {
      return {};
    }
  }

}