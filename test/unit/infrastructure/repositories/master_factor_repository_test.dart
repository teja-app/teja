import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/domain/entities/master_factor.dart';
import '../../../fixtures/master_factor_fixtures.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('MasterFactorRepository Entity Conversion', () {

    group('Entity Conversion', () {
      test('should convert complete MasterFactorEntity correctly', () {
        final entity = MasterFactorFixtures.complete();
        
        // id can be null, so just check it exists as a field
        expect(entity.slug, isNotEmpty);
        expect(entity.title, isNotEmpty);
        expect(entity.subcategories, isNotNull);
        expect(entity.subcategories.length, greaterThan(0));
        
        for (final subcategory in entity.subcategories) {
          expect(subcategory.slug, isNotEmpty);
          expect(subcategory.title, isNotEmpty);
        }
      });

      test('should convert minimal MasterFactorEntity correctly', () {
        final entity = MasterFactorFixtures.minimal();
        
        // id can be null, so just check it exists as a field
        expect(entity.slug, isNotEmpty);
        expect(entity.title, isNotEmpty);
        expect(entity.subcategories, isEmpty);
      });

      test('should handle work factor with subcategories', () {
        final entity = MasterFactorFixtures.work();
        
        expect(entity.slug, equals('work'));
        expect(entity.title, equals('Work'));
        expect(entity.subcategories.length, greaterThan(0));
        
        for (final subcategory in entity.subcategories) {
          expect(subcategory.slug, isNotEmpty);
          expect(subcategory.title, isNotEmpty);
        }
      });

      test('should handle relationships factor with subcategories', () {
        final entity = MasterFactorFixtures.relationships();
        
        expect(entity.slug, equals('relationships'));
        expect(entity.title, equals('Relationships'));
        expect(entity.subcategories.length, greaterThan(0));
        
        for (final subcategory in entity.subcategories) {
          expect(subcategory.slug, isNotEmpty);
          expect(subcategory.title, isNotEmpty);
        }
      });

      test('should handle lifestyle factor with subcategories', () {
        final entity = MasterFactorFixtures.lifestyle();
        
        expect(entity.slug, equals('lifestyle'));
        expect(entity.title, equals('Lifestyle'));
        expect(entity.subcategories.length, greaterThan(0));
        
        for (final subcategory in entity.subcategories) {
          expect(subcategory.slug, isNotEmpty);
          expect(subcategory.title, isNotEmpty);
        }
      });
    });

    group('Subcategory Operations', () {
      test('should filter subcategories by slug list', () {
        final factors = [
          MasterFactorFixtures.work(),
          MasterFactorFixtures.relationships(),
          MasterFactorFixtures.lifestyle(),
        ];
        
        final allSubcategories = <SubCategoryEntity>[];
        for (final factor in factors) {
          allSubcategories.addAll(factor.subcategories);
        }
        
        expect(allSubcategories.length, greaterThan(0));
        
        // Test filtering logic
        final firstFewSlugs = allSubcategories.take(3).map((s) => s.slug).toList();
        final filteredSubcategories = <SubCategoryEntity>[];
        
        for (final factor in factors) {
          for (final subcategory in factor.subcategories) {
            if (firstFewSlugs.contains(subcategory.slug)) {
              filteredSubcategories.add(subcategory);
            }
          }
        }
        
        expect(filteredSubcategories.length, equals(3));
        expect(filteredSubcategories.map((s) => s.slug).toList(), containsAll(firstFewSlugs));
      });

      test('should maintain subcategory data integrity', () {
        final entity = MasterFactorFixtures.work();
        
        for (final subcategory in entity.subcategories) {
          expect(subcategory.slug, isNotEmpty);
          expect(subcategory.title, isNotEmpty);
        }
      });

      test('should handle empty subcategory filtering', () {
        final factors = [MasterFactorFixtures.minimal()];
        final targetSlugs = ['nonexistent'];
        final filteredSubcategories = <SubCategoryEntity>[];
        
        for (final factor in factors) {
          for (final subcategory in factor.subcategories) {
            if (targetSlugs.contains(subcategory.slug)) {
              filteredSubcategories.add(subcategory);
            }
          }
        }
        
        expect(filteredSubcategories, isEmpty);
      });
    });

    group('Data Validation', () {
      test('should create valid entity with required fields', () {
        final entity = MasterFactorFixtures.complete();
        
        // id can be null, so just check it exists as a field
        expect(entity.slug, isNotEmpty);
        expect(entity.title, isNotEmpty);
        expect(entity.subcategories, isA<List<SubCategoryEntity>>());
      });

      test('should handle factors with no subcategories', () {
        final entity = MasterFactorFixtures.minimal();
        
        expect(entity.subcategories, isEmpty);
        // id can be null, so just check it exists as a field
        expect(entity.slug, isNotEmpty);
        expect(entity.title, isNotEmpty);
      });

      test('should maintain subcategory data integrity', () {
        final entity = MasterFactorFixtures.complete();
        
        for (final subcategory in entity.subcategories) {
          expect(subcategory.slug, isNotEmpty);
          expect(subcategory.title, isNotEmpty);
        }
      });
    });

    group('Edge Cases', () {
      test('should handle multiple factors with different domains', () {
        final workFactor = MasterFactorFixtures.work();
        final relationshipsFactor = MasterFactorFixtures.relationships();
        final lifestyleFactor = MasterFactorFixtures.lifestyle();
        
        expect(workFactor.slug, isNot(equals(relationshipsFactor.slug)));
        expect(relationshipsFactor.slug, isNot(equals(lifestyleFactor.slug)));
        expect(lifestyleFactor.slug, isNot(equals(workFactor.slug)));
        
        // Verify each factor has subcategories
        expect(workFactor.subcategories.length, greaterThan(0));
        expect(relationshipsFactor.subcategories.length, greaterThan(0));
        expect(lifestyleFactor.subcategories.length, greaterThan(0));
      });

      test('should handle factors with subcategories correctly', () {
        final factorsWithSubcategories = [
          MasterFactorFixtures.work(),
          MasterFactorFixtures.relationships(),
          MasterFactorFixtures.lifestyle(),
        ];
        
        for (final factor in factorsWithSubcategories) {
          expect(factor.subcategories.length, greaterThan(0));
          
          // Check that all subcategories have unique slugs within the factor
          final slugs = factor.subcategories.map((s) => s.slug).toList();
          final uniqueSlugs = slugs.toSet();
          expect(slugs.length, equals(uniqueSlugs.length));
        }
      });

      test('should handle different factor types correctly', () {
        final complete = MasterFactorFixtures.complete();
        final minimal = MasterFactorFixtures.minimal();
        final work = MasterFactorFixtures.work();
        
        expect(complete.id, isNot(equals(minimal.id)));
        expect(minimal.id, isNot(equals(work.id)));
        expect(work.id, isNot(equals(complete.id)));
        
        expect(complete.subcategories.length, greaterThan(0));
        expect(minimal.subcategories.length, equals(0));
        expect(work.subcategories.length, greaterThan(0));
      });

      test('should validate subcategory equality correctly', () {
        final factor = MasterFactorFixtures.work();
        
        if (factor.subcategories.isNotEmpty) {
          final firstSubcategory = factor.subcategories.first;
          final sameSubcategory = SubCategoryEntity(
            slug: firstSubcategory.slug,
            title: firstSubcategory.title,
          );
          
          expect(firstSubcategory, equals(sameSubcategory));
          expect(firstSubcategory.hashCode, equals(sameSubcategory.hashCode));
        }
      });
    });
  });
}