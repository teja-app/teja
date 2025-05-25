import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/infrastructure/repositories/master_feeling.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import '../../../fixtures/master_feeling_fixtures.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('MasterFeelingRepository', () {
    late MasterFeelingRepository repository;
    late MockDatabase mockDatabase;

    setUp(() {
      mockDatabase = MockDatabase();
      repository = MasterFeelingRepository(mockDatabase);
    });

    group('Repository Creation', () {
      test('should create repository with database', () {
        expect(repository, isNotNull);
      });
    });

    group('Entity Creation Tests', () {
      test('should create proper MasterFeelingEntity structure', () {
        // Test that our fixtures create proper entities
        final category = MasterFeelingFixtures.category();
        final subcategory = MasterFeelingFixtures.subcategory();
        final feeling = MasterFeelingFixtures.feeling();

        expect(category.type, equals('category'));
        expect(category.parentSlug, isNull);
        expect(category.energy, isNull);
        expect(category.pleasantness, isNull);

        expect(subcategory.type, equals('subcategory'));
        expect(subcategory.parentSlug, isNotNull);
        expect(subcategory.energy, isNull);
        expect(subcategory.pleasantness, isNull);

        expect(feeling.type, equals('feeling'));
        expect(feeling.parentSlug, isNotNull);
        expect(feeling.energy, isNotNull);
        expect(feeling.pleasantness, isNotNull);
      });

      test('should create hierarchical structure correctly', () {
        final hierarchical = MasterFeelingFixtures.hierarchical();
        
        expect(hierarchical.length, equals(4));
        
        final categories = hierarchical.where((f) => f.type == 'category').toList();
        final subcategories = hierarchical.where((f) => f.type == 'subcategory').toList();
        final feelings = hierarchical.where((f) => f.type == 'feeling').toList();
        
        expect(categories.length, equals(1));
        expect(subcategories.length, equals(1));
        expect(feelings.length, equals(2));
        
        // Check relationships
        final category = categories.first;
        final subcategory = subcategories.first;
        
        expect(subcategory.parentSlug, equals(category.slug));
        
        for (final feeling in feelings) {
          expect(feeling.parentSlug, equals(subcategory.slug));
        }
      });

      test('should create mixed types correctly', () {
        final mixed = MasterFeelingFixtures.mixedTypes();
        
        expect(mixed.length, equals(6));
        
        // Verify we have the expected types
        final typesCounts = <String, int>{};
        for (final item in mixed) {
          typesCounts[item.type] = (typesCounts[item.type] ?? 0) + 1;
        }
        
        expect(typesCounts['category'], equals(2));
        expect(typesCounts['subcategory'], equals(2));
        expect(typesCounts['feeling'], equals(2));
      });

      test('should create feelings with proper energy and pleasantness ranges', () {
        final feelings = MasterFeelingFixtures.feelingsOnly(count: 10);
        
        expect(feelings.length, equals(10));
        
        for (final feeling in feelings) {
          expect(feeling.type, equals('feeling'));
          expect(feeling.energy, isNotNull);
          expect(feeling.pleasantness, isNotNull);
          expect(feeling.energy! >= 1 && feeling.energy! <= 10, isTrue);
          expect(feeling.pleasantness! >= 1 && feeling.pleasantness! <= 10, isTrue);
        }
      });
    });

    group('Data Validation', () {
      test('should handle minimal feeling requirements', () {
        final minimal = MasterFeelingFixtures.minimal(
          name: 'Test',
          slug: 'test',
          type: 'feeling',
        );
        
        expect(minimal.name, equals('Test'));
        expect(minimal.slug, equals('test'));
        expect(minimal.type, equals('feeling'));
        expect(minimal.id, isNotNull);
      });

      test('should handle different type validations', () {
        final types = ['category', 'subcategory', 'feeling'];
        
        for (final type in types) {
          late MasterFeelingEntity entity;
          
          switch (type) {
            case 'category':
              entity = MasterFeelingFixtures.category();
              break;
            case 'subcategory':
              entity = MasterFeelingFixtures.subcategory();
              break;
            case 'feeling':
              entity = MasterFeelingFixtures.feeling();
              break;
          }
          
          expect(entity.type, equals(type));
          expect(entity.name, isNotEmpty);
          expect(entity.slug, isNotEmpty);
          expect(entity.id, isNotNull);
        }
      });

      test('should validate energy and pleasantness for feelings only', () {
        final feeling = MasterFeelingFixtures.feeling(energy: 5, pleasantness: 7);
        final category = MasterFeelingFixtures.category();
        final subcategory = MasterFeelingFixtures.subcategory();
        
        expect(feeling.energy, equals(5));
        expect(feeling.pleasantness, equals(7));
        
        expect(category.energy, isNull);
        expect(category.pleasantness, isNull);
        
        expect(subcategory.energy, isNull);
        expect(subcategory.pleasantness, isNull);
      });
    });

    group('Edge Cases', () {
      test('should handle extreme energy and pleasantness values', () {
        final extreme1 = MasterFeelingFixtures.feeling(energy: 10, pleasantness: 1);
        final extreme2 = MasterFeelingFixtures.feeling(energy: 1, pleasantness: 10);
        final zero = MasterFeelingFixtures.feeling(energy: 0, pleasantness: 0);
        
        expect(extreme1.energy, equals(10));
        expect(extreme1.pleasantness, equals(1));
        
        expect(extreme2.energy, equals(1));
        expect(extreme2.pleasantness, equals(10));
        
        expect(zero.energy, equals(0));
        expect(zero.pleasantness, equals(0));
      });

      test('should handle empty and special string values', () {
        final entity = MasterFeelingEntity(
          name: '',
          slug: '',
          type: 'feeling',
          parentSlug: '',
        );
        
        expect(entity.name, equals(''));
        expect(entity.slug, equals(''));
        expect(entity.parentSlug, equals(''));
      });

      test('should handle null optional fields', () {
        final entity = MasterFeelingEntity(
          name: 'Test',
          slug: 'test',
          type: 'category',
          parentSlug: null,
          energy: null,
          pleasantness: null,
        );
        
        expect(entity.parentSlug, isNull);
        expect(entity.energy, isNull);
        expect(entity.pleasantness, isNull);
      });
    });
  });
}