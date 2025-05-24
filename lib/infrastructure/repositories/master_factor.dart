import 'package:cbl/cbl.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_factor.dart' as cbl;

class MasterFactorRepository {
  final Database database;

  MasterFactorRepository(this.database);

  Future<Map<String, String>> addOrUpdateFactors(List<cbl.MasterFactor> factors) async {
    Map<String, String> factorIds = {};
    
    try {
      await database.inBatch(() async {
        final collection = await database.defaultCollection;
        
        for (var factor in factors) {
          // Search for existing factor with the same slug
          final query = const QueryBuilder()
              .select(SelectResult.expression(Meta.id))
              .from(DataSource.collection(collection))
              .where(Expression.property('slug').equalTo(Expression.string(factor.slug)));
          
          final resultSet = await query.execute();
          String? existingId;
          
          await for (final result in resultSet.asStream()) {
            existingId = result.string(0);
            break; // We only need the first match
          }
          
          final docId = existingId ?? factor.id ?? _generateId();
          final doc = MutableDocument.withId(docId);
          
          final data = {
            'slug': factor.slug,
            'title': factor.title,
            'subcategories': factor.subcategories
                ?.map((subCategory) => {
                      'slug': subCategory.slug,
                      'title': subCategory.title,
                    })
                .toList(),
          };
          
          doc.setData(data);
          await collection.saveDocument(doc);
          
          factorIds[factor.slug] = docId;
        }
      });
      
      return factorIds;
    } catch (e) {
      print('Error adding or updating factors: $e');
      throw Exception('Failed to save factors: $e');
    }
  }

  Future<List<cbl.MasterFactor>> getAllFactors() async {
    try {
      final collection = await database.defaultCollection;
      
      final query = const QueryBuilder()
          .select(SelectResult.expression(Meta.id), SelectResult.all())
          .from(DataSource.collection(collection))
          .where(Expression.property('slug').notNullOrMissing()); // Filter for master factors (they have slug property)
      
      final resultSet = await query.execute();
      final factors = <cbl.MasterFactor>[];
      
      await for (final result in resultSet.asStream()) {
        final docId = result.string(0);
        final dictionary = result.dictionary(1);
        
        if (docId != null && dictionary != null) {
          // Check if this is a factor document (has both slug and title)
          if (dictionary.string('slug') != null && dictionary.string('title') != null) {
            final doc = await collection.document(docId);
            if (doc != null) {
              factors.add(cbl.ImmutableMasterFactor.internal(doc));
            }
          }
        }
      }
      
      return factors;
    } catch (e) {
      print('Error getting all factors: $e');
      return [];
    }
  }

  Future<List<MasterFactorEntity>> getAllFactorEntities() async {
    List<cbl.MasterFactor> factors = await getAllFactors();
    return factors.map(toEntity).toList();
  }

  MasterFactorEntity toEntity(cbl.MasterFactor factor) {
    return MasterFactorEntity(
      id: factor.id ?? '',
      slug: factor.slug,
      title: factor.title,
      subcategories: factor.subcategories
              ?.map((subCategory) => SubCategoryEntity(
                    slug: subCategory.slug,
                    title: subCategory.title,
                  ))
              .toList() ??
          [],
    );
  }

  Future<List<SubCategoryEntity>> filterSubCategoryBySlugs(List<String> slugs) async {
    try {
      // Fetch all factors
      List<cbl.MasterFactor> factors = await getAllFactors();
      
      // Initialize a list to collect matching subcategories
      List<SubCategoryEntity> matchingSubCategories = [];
      
      // Iterate over each factor
      for (var factor in factors) {
        // Check if subcategories exist and are not empty
        if (factor.subcategories != null && factor.subcategories!.isNotEmpty) {
          // Filter subcategories that match any of the slugs and add them to the list
          for (var subCategory in factor.subcategories!) {
            if (slugs.contains(subCategory.slug)) {
              matchingSubCategories.add(SubCategoryEntity(
                slug: subCategory.slug,
                title: subCategory.title,
              ));
            }
          }
        }
      }
      
      return matchingSubCategories;
    } catch (e) {
      print('Error filtering subcategories by slugs: $e');
      return [];
    }
  }

  String _generateId() {
    // Generate a unique ID for new documents
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}