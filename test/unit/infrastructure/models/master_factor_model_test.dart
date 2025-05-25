import 'package:flutter_test/flutter_test.dart';
import 'package:teja/domain/entities/master_factor.dart';
import '../../../fixtures/master_factor_fixtures.dart';

void main() {
  group('MasterFactor Model', () {
    group('MasterFactorEntity', () {
      test('should create master factor entity with all fields', () {
        // Arrange & Act
        final factor = MasterFactorFixtures.complete();
        
        // Assert
        expect(factor.id, isNotNull);
        expect(factor.slug, equals('health'));
        expect(factor.title, equals('Health'));
        expect(factor.subcategories, isNotEmpty);
        expect(factor.subcategories.length, equals(3));
      });

      test('should create minimal master factor entity', () {
        // Arrange & Act
        final factor = MasterFactorFixtures.minimal();
        
        // Assert
        expect(factor.slug, equals('work'));
        expect(factor.title, equals('Work'));
        expect(factor.subcategories, isEmpty);
      });

      test('should create work factor with correct subcategories', () {
        // Arrange & Act
        final factor = MasterFactorFixtures.work();
        
        // Assert
        expect(factor.slug, equals('work'));
        expect(factor.title, equals('Work'));
        expect(factor.subcategories.length, equals(4));
        expect(factor.subcategories.map((s) => s.slug), contains('meetings'));
        expect(factor.subcategories.map((s) => s.slug), contains('deadlines'));
        expect(factor.subcategories.map((s) => s.slug), contains('colleagues'));
        expect(factor.subcategories.map((s) => s.slug), contains('projects'));
      });

      test('should create relationships factor with correct subcategories', () {
        // Arrange & Act
        final factor = MasterFactorFixtures.relationships();
        
        // Assert
        expect(factor.slug, equals('relationships'));
        expect(factor.title, equals('Relationships'));
        expect(factor.subcategories.length, equals(4));
        expect(factor.subcategories.map((s) => s.slug), contains('family'));
        expect(factor.subcategories.map((s) => s.slug), contains('friends'));
        expect(factor.subcategories.map((s) => s.slug), contains('romantic'));
        expect(factor.subcategories.map((s) => s.slug), contains('social'));
      });

      test('should create lifestyle factor with correct subcategories', () {
        // Arrange & Act
        final factor = MasterFactorFixtures.lifestyle();
        
        // Assert
        expect(factor.slug, equals('lifestyle'));
        expect(factor.title, equals('Lifestyle'));
        expect(factor.subcategories.length, equals(3));
        expect(factor.subcategories.map((s) => s.slug), contains('hobbies'));
        expect(factor.subcategories.map((s) => s.slug), contains('travel'));
        expect(factor.subcategories.map((s) => s.slug), contains('entertainment'));
      });

      test('should create multiple factors correctly', () {
        // Arrange & Act
        final factors = MasterFactorFixtures.multipleFactors();
        
        // Assert
        expect(factors.length, equals(5));
        expect(factors.map((f) => f.slug), contains('health'));
        expect(factors.map((f) => f.slug), contains('work'));
        expect(factors.map((f) => f.slug), contains('relationships'));
        expect(factors.map((f) => f.slug), contains('lifestyle'));
        expect(factors.map((f) => f.slug), contains('environment'));
      });

      test('should create factors with specific slugs', () {
        // Arrange
        final slugs = ['health', 'work', 'custom-slug'];
        
        // Act
        final factors = MasterFactorFixtures.factorsWithSlugs(slugs);
        
        // Assert
        expect(factors.length, equals(3));
        expect(factors[0].slug, equals('health'));
        expect(factors[1].slug, equals('work'));
        expect(factors[2].slug, equals('custom-slug'));
        expect(factors[2].title, equals('CUSTOM-SLUG'));
      });
    });

    group('SubCategoryEntity', () {
      test('should create subcategory entity correctly', () {
        // Arrange & Act
        final subcategory = SubCategoryEntity(
          slug: 'exercise',
          title: 'Exercise',
        );
        
        // Assert
        expect(subcategory.slug, equals('exercise'));
        expect(subcategory.title, equals('Exercise'));
      });

      test('should implement equality correctly', () {
        // Arrange
        final subcategory1 = SubCategoryEntity(
          slug: 'exercise',
          title: 'Exercise',
        );
        final subcategory2 = SubCategoryEntity(
          slug: 'exercise',
          title: 'Physical Activity', // Different title
        );
        final subcategory3 = SubCategoryEntity(
          slug: 'nutrition',
          title: 'Nutrition',
        );
        
        // Act & Assert
        expect(subcategory1, equals(subcategory2)); // Same slug
        expect(subcategory1, isNot(equals(subcategory3))); // Different slug
      });

      test('should implement hashCode correctly', () {
        // Arrange
        final subcategory1 = SubCategoryEntity(
          slug: 'exercise',
          title: 'Exercise',
        );
        final subcategory2 = SubCategoryEntity(
          slug: 'exercise',
          title: 'Physical Activity',
        );
        
        // Act & Assert
        expect(subcategory1.hashCode, equals(subcategory2.hashCode));
        expect(subcategory1.hashCode, equals('exercise'.hashCode));
      });

      test('should create multiple subcategories correctly', () {
        // Arrange & Act
        final subcategories = MasterFactorFixtures.subcategories();
        
        // Assert
        expect(subcategories.length, equals(7));
        expect(subcategories.map((s) => s.slug), contains('exercise'));
        expect(subcategories.map((s) => s.slug), contains('nutrition'));
        expect(subcategories.map((s) => s.slug), contains('sleep'));
        expect(subcategories.map((s) => s.slug), contains('meetings'));
        expect(subcategories.map((s) => s.slug), contains('deadlines'));
        expect(subcategories.map((s) => s.slug), contains('family'));
        expect(subcategories.map((s) => s.slug), contains('friends'));
      });

      test('should create subcategories with specific slugs', () {
        // Arrange
        final slugs = ['custom-slug', 'another-slug', 'third-slug'];
        
        // Act
        final subcategories = MasterFactorFixtures.subcategoriesWithSlugs(slugs);
        
        // Assert
        expect(subcategories.length, equals(3));
        expect(subcategories[0].slug, equals('custom-slug'));
        expect(subcategories[0].title, equals('Custom Slug'));
        expect(subcategories[1].slug, equals('another-slug'));
        expect(subcategories[1].title, equals('Another Slug'));
        expect(subcategories[2].slug, equals('third-slug'));
        expect(subcategories[2].title, equals('Third Slug'));
      });

      test('should handle slug to title conversion correctly', () {
        // Arrange
        final testCases = {
          'simple': 'Simple',
          'two-words': 'Two Words',
          'multi-word-slug': 'Multi Word Slug',
          'already-capitalized': 'Already Capitalized',
          'single': 'Single',
        };
        
        testCases.forEach((slug, expectedTitle) {
          // Act
          final subcategories = MasterFactorFixtures.subcategoriesWithSlugs([slug]);
          
          // Assert
          expect(subcategories.first.title, equals(expectedTitle),
              reason: 'Failed for slug: $slug');
        });
      });
    });


    group('Edge Cases', () {
      test('should handle empty subcategories list', () {
        // Arrange & Act
        final factor = MasterFactorEntity(
          slug: 'empty-factor',
          title: 'Empty Factor',
          subcategories: [],
        );
        
        // Assert
        expect(factor.subcategories, isEmpty);
        expect(factor.subcategories.length, equals(0));
      });

      test('should handle null id correctly', () {
        // Arrange & Act
        final factor = MasterFactorEntity(
          id: null,
          slug: 'no-id-factor',
          title: 'No ID Factor',
          subcategories: [],
        );
        
        // Assert
        expect(factor.id, isNull);
        expect(factor.slug, equals('no-id-factor'));
        expect(factor.title, equals('No ID Factor'));
      });

      test('should handle very long slug and title', () {
        // Arrange
        final longSlug = 'a' * 1000;
        final longTitle = 'B' * 1000;
        
        // Act
        final factor = MasterFactorEntity(
          slug: longSlug,
          title: longTitle,
          subcategories: [],
        );
        
        // Assert
        expect(factor.slug.length, equals(1000));
        expect(factor.title.length, equals(1000));
      });

      test('should handle special characters in slug and title', () {
        // Arrange
        final specialSlug = 'slug-with-émojis-😊-and-spëcials';
        final specialTitle = 'Title with émojis 😊 and spëcial chârs: ñ, ü, é';
        
        // Act
        final factor = MasterFactorEntity(
          slug: specialSlug,
          title: specialTitle,
          subcategories: [],
        );
        
        // Assert
        expect(factor.slug, equals(specialSlug));
        expect(factor.title, equals(specialTitle));
      });

      test('should handle many subcategories', () {
        // Arrange
        final manySubcategories = List.generate(100, (index) => 
            SubCategoryEntity(
              slug: 'sub-$index',
              title: 'Subcategory $index',
            ));
        
        // Act
        final factor = MasterFactorEntity(
          slug: 'many-subs',
          title: 'Many Subcategories',
          subcategories: manySubcategories,
        );
        
        // Assert
        expect(factor.subcategories.length, equals(100));
        expect(factor.subcategories.first.slug, equals('sub-0'));
        expect(factor.subcategories.last.slug, equals('sub-99'));
      });

      test('should handle duplicate subcategories by slug', () {
        // Arrange
        final duplicateSubcategories = [
          SubCategoryEntity(slug: 'duplicate', title: 'First'),
          SubCategoryEntity(slug: 'duplicate', title: 'Second'),
          SubCategoryEntity(slug: 'unique', title: 'Unique'),
        ];
        
        // Act
        final factor = MasterFactorEntity(
          slug: 'test-duplicates',
          title: 'Test Duplicates',
          subcategories: duplicateSubcategories,
        );
        
        // Assert
        expect(factor.subcategories.length, equals(3));
        // Test equality (should be equal even with different titles)
        expect(factor.subcategories[0], equals(factor.subcategories[1]));
        expect(factor.subcategories[0], isNot(equals(factor.subcategories[2])));
      });

      test('should handle empty string slug and title', () {
        // Arrange & Act
        final factor = MasterFactorEntity(
          slug: '',
          title: '',
          subcategories: [],
        );
        
        // Assert
        expect(factor.slug, equals(''));
        expect(factor.title, equals(''));
      });
    });

    group('Real-world Scenarios', () {
      test('should create realistic health factor', () {
        // Arrange & Act
        final healthFactor = MasterFactorEntity(
          id: 'health-001',
          slug: 'health',
          title: 'Health & Wellness',
          subcategories: [
            SubCategoryEntity(slug: 'exercise', title: 'Exercise & Fitness'),
            SubCategoryEntity(slug: 'nutrition', title: 'Nutrition & Diet'),
            SubCategoryEntity(slug: 'sleep', title: 'Sleep Quality'),
            SubCategoryEntity(slug: 'mental-health', title: 'Mental Health'),
            SubCategoryEntity(slug: 'medical-care', title: 'Medical Care'),
          ],
        );
        
        // Assert
        expect(healthFactor.slug, equals('health'));
        expect(healthFactor.title, equals('Health & Wellness'));
        expect(healthFactor.subcategories.length, equals(5));
        expect(healthFactor.subcategories.map((s) => s.slug), 
               containsAll(['exercise', 'nutrition', 'sleep', 'mental-health', 'medical-care']));
      });

      test('should create realistic work factor', () {
        // Arrange & Act
        final workFactor = MasterFactorEntity(
          id: 'work-001',
          slug: 'work',
          title: 'Work & Career',
          subcategories: [
            SubCategoryEntity(slug: 'workload', title: 'Workload & Pressure'),
            SubCategoryEntity(slug: 'colleagues', title: 'Colleagues & Team'),
            SubCategoryEntity(slug: 'management', title: 'Management & Leadership'),
            SubCategoryEntity(slug: 'career-growth', title: 'Career Growth'),
            SubCategoryEntity(slug: 'work-life-balance', title: 'Work-Life Balance'),
            SubCategoryEntity(slug: 'compensation', title: 'Salary & Benefits'),
          ],
        );
        
        // Assert
        expect(workFactor.slug, equals('work'));
        expect(workFactor.title, equals('Work & Career'));
        expect(workFactor.subcategories.length, equals(6));
      });
    });
  });
}