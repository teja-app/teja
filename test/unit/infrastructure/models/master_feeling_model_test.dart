import 'package:flutter_test/flutter_test.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import '../../../fixtures/master_feeling_fixtures.dart';

void main() {
  group('MasterFeelingEntity', () {
    group('Creation', () {
      test('should create feeling with required fields', () {
        final feeling = MasterFeelingFixtures.minimal();
        
        expect(feeling.name, isNotEmpty);
        expect(feeling.slug, isNotEmpty);
        expect(feeling.type, isNotEmpty);
      });

      test('should create category correctly', () {
        final category = MasterFeelingFixtures.category(
          name: 'Positive',
          slug: 'positive',
        );
        
        expect(category.name, equals('Positive'));
        expect(category.slug, equals('positive'));
        expect(category.type, equals('category'));
        expect(category.parentSlug, isNull);
        expect(category.energy, isNull);
        expect(category.pleasantness, isNull);
      });

      test('should create subcategory correctly', () {
        final subcategory = MasterFeelingFixtures.subcategory(
          name: 'Joy',
          slug: 'joy',
          parentSlug: 'positive',
        );
        
        expect(subcategory.name, equals('Joy'));
        expect(subcategory.slug, equals('joy'));
        expect(subcategory.type, equals('subcategory'));
        expect(subcategory.parentSlug, equals('positive'));
        expect(subcategory.energy, isNull);
        expect(subcategory.pleasantness, isNull);
      });

      test('should create feeling with energy and pleasantness', () {
        final feeling = MasterFeelingFixtures.feeling(
          name: 'Happy',
          slug: 'happy',
          parentSlug: 'joy',
          energy: 7,
          pleasantness: 8,
        );
        
        expect(feeling.name, equals('Happy'));
        expect(feeling.slug, equals('happy'));
        expect(feeling.type, equals('feeling'));
        expect(feeling.parentSlug, equals('joy'));
        expect(feeling.energy, equals(7));
        expect(feeling.pleasantness, equals(8));
      });
    });

    group('Equality', () {
      test('should be equal when all properties match', () {
        final feeling1 = MasterFeelingFixtures.feeling(
          id: 'test-id',
          name: 'Happy',
          slug: 'happy',
          energy: 7,
          pleasantness: 8,
        );
        
        final feeling2 = MasterFeelingFixtures.feeling(
          id: 'test-id',
          name: 'Happy',
          slug: 'happy',
          energy: 7,
          pleasantness: 8,
        );
        
        expect(feeling1, equals(feeling2));
        expect(feeling1.hashCode, equals(feeling2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final feeling1 = MasterFeelingFixtures.feeling(name: 'Happy');
        final feeling2 = MasterFeelingFixtures.feeling(name: 'Sad');
        
        expect(feeling1, isNot(equals(feeling2)));
        expect(feeling1.hashCode, isNot(equals(feeling2.hashCode)));
      });

      test('should not be equal to other types', () {
        final feeling = MasterFeelingFixtures.feeling();
        
        expect(feeling, isNot(equals('not a feeling')));
        expect(feeling, isNot(equals(42)));
        expect(feeling, isNot(equals(null)));
      });
    });

    group('CopyWith', () {
      test('should copy with new name', () {
        final original = MasterFeelingFixtures.feeling(name: 'Happy');
        final copied = original.copyWith(name: 'Joyful');
        
        expect(copied.name, equals('Joyful'));
        expect(copied.slug, equals(original.slug));
        expect(copied.type, equals(original.type));
        expect(copied.parentSlug, equals(original.parentSlug));
        expect(copied.energy, equals(original.energy));
        expect(copied.pleasantness, equals(original.pleasantness));
      });

      test('should copy with new slug', () {
        final original = MasterFeelingFixtures.feeling(slug: 'happy');
        final copied = original.copyWith(slug: 'joyful');
        
        expect(copied.slug, equals('joyful'));
        expect(copied.name, equals(original.name));
      });

      test('should copy with new type', () {
        final original = MasterFeelingFixtures.feeling();
        final copied = original.copyWith(type: 'subcategory');
        
        expect(copied.type, equals('subcategory'));
        expect(copied.name, equals(original.name));
        expect(copied.slug, equals(original.slug));
      });

      test('should copy with new parentSlug', () {
        final original = MasterFeelingFixtures.feeling(parentSlug: 'joy');
        final copied = original.copyWith(parentSlug: 'sadness');
        
        expect(copied.parentSlug, equals('sadness'));
        expect(copied.name, equals(original.name));
      });

      test('should copy with new energy and pleasantness', () {
        final original = MasterFeelingFixtures.feeling(energy: 5, pleasantness: 6);
        final copied = original.copyWith(energy: 8, pleasantness: 9);
        
        expect(copied.energy, equals(8));
        expect(copied.pleasantness, equals(9));
        expect(copied.name, equals(original.name));
      });

      test('should preserve values when null is passed', () {
        final original = MasterFeelingFixtures.feeling(
          name: 'Happy',
          slug: 'happy',
          energy: 7,
          pleasantness: 8,
        );
        final copied = original.copyWith();
        
        expect(copied.name, equals(original.name));
        expect(copied.slug, equals(original.slug));
        expect(copied.energy, equals(original.energy));
        expect(copied.pleasantness, equals(original.pleasantness));
      });

      test('should preserve values when null is passed explicitly (due to ?? operator)', () {
        final original = MasterFeelingFixtures.feeling(
          parentSlug: 'joy',
          energy: 7,
          pleasantness: 8,
        );
        final copied = original.copyWith(
          parentSlug: null,
          energy: null,
          pleasantness: null,
        );
        
        // Due to ?? operator, null values preserve original values
        expect(copied.parentSlug, equals(original.parentSlug));
        expect(copied.energy, equals(original.energy));
        expect(copied.pleasantness, equals(original.pleasantness));
        expect(copied.name, equals(original.name));
        expect(copied.slug, equals(original.slug));
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        final feeling = MasterFeelingEntity(
          name: '',
          slug: '',
          type: '',
        );
        
        expect(feeling.name, equals(''));
        expect(feeling.slug, equals(''));
        expect(feeling.type, equals(''));
      });

      test('should handle extreme energy and pleasantness values', () {
        final feeling = MasterFeelingEntity(
          name: 'Extreme',
          slug: 'extreme',
          type: 'feeling',
          energy: 10,
          pleasantness: 1,
        );
        
        expect(feeling.energy, equals(10));
        expect(feeling.pleasantness, equals(1));
      });

      test('should handle zero energy and pleasantness', () {
        final feeling = MasterFeelingEntity(
          name: 'Neutral',
          slug: 'neutral',
          type: 'feeling',
          energy: 0,
          pleasantness: 0,
        );
        
        expect(feeling.energy, equals(0));
        expect(feeling.pleasantness, equals(0));
      });
    });

    group('Hierarchical Structure', () {
      test('should create hierarchical feelings correctly', () {
        final feelings = MasterFeelingFixtures.hierarchical();
        
        expect(feelings.length, equals(4));
        
        final category = feelings.firstWhere((f) => f.type == 'category');
        final subcategory = feelings.firstWhere((f) => f.type == 'subcategory');
        final feelingItems = feelings.where((f) => f.type == 'feeling').toList();
        
        expect(category.name, equals('Positive'));
        expect(category.parentSlug, isNull);
        
        expect(subcategory.name, equals('Joy'));
        expect(subcategory.parentSlug, equals('positive'));
        
        expect(feelingItems.length, equals(2));
        for (final feeling in feelingItems) {
          expect(feeling.parentSlug, equals('joy'));
          expect(feeling.energy, isNotNull);
          expect(feeling.pleasantness, isNotNull);
        }
      });
    });
  });
}