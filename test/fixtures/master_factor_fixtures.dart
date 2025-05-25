import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_factor.dart' as cbl;
import 'package:uuid/uuid.dart';

class MasterFactorFixtures {
  static final _uuid = Uuid();
  
  /// Create a complete master factor with subcategories
  static MasterFactorEntity complete({
    String? id,
    String? slug,
    String? title,
  }) {
    return MasterFactorEntity(
      id: id ?? 'factor-${_uuid.v4()}',
      slug: slug ?? 'health',
      title: title ?? 'Health',
      subcategories: [
        SubCategoryEntity(
          slug: 'exercise',
          title: 'Exercise',
        ),
        SubCategoryEntity(
          slug: 'nutrition',
          title: 'Nutrition',
        ),
        SubCategoryEntity(
          slug: 'sleep',
          title: 'Sleep',
        ),
      ],
    );
  }
  
  /// Create a minimal master factor without subcategories
  static MasterFactorEntity minimal({
    String? slug,
    String? title,
  }) {
    return MasterFactorEntity(
      slug: slug ?? 'work',
      title: title ?? 'Work',
      subcategories: [],
    );
  }
  
  /// Create work-related master factor
  static MasterFactorEntity work() {
    return MasterFactorEntity(
      id: 'factor-work-${_uuid.v4()}',
      slug: 'work',
      title: 'Work',
      subcategories: [
        SubCategoryEntity(
          slug: 'meetings',
          title: 'Meetings',
        ),
        SubCategoryEntity(
          slug: 'deadlines',
          title: 'Deadlines',
        ),
        SubCategoryEntity(
          slug: 'colleagues',
          title: 'Colleagues',
        ),
        SubCategoryEntity(
          slug: 'projects',
          title: 'Projects',
        ),
      ],
    );
  }
  
  /// Create relationships master factor
  static MasterFactorEntity relationships() {
    return MasterFactorEntity(
      id: 'factor-relationships-${_uuid.v4()}',
      slug: 'relationships',
      title: 'Relationships',
      subcategories: [
        SubCategoryEntity(
          slug: 'family',
          title: 'Family',
        ),
        SubCategoryEntity(
          slug: 'friends',
          title: 'Friends',
        ),
        SubCategoryEntity(
          slug: 'romantic',
          title: 'Romantic',
        ),
        SubCategoryEntity(
          slug: 'social',
          title: 'Social',
        ),
      ],
    );
  }
  
  /// Create lifestyle master factor
  static MasterFactorEntity lifestyle() {
    return MasterFactorEntity(
      id: 'factor-lifestyle-${_uuid.v4()}',
      slug: 'lifestyle',
      title: 'Lifestyle',
      subcategories: [
        SubCategoryEntity(
          slug: 'hobbies',
          title: 'Hobbies',
        ),
        SubCategoryEntity(
          slug: 'travel',
          title: 'Travel',
        ),
        SubCategoryEntity(
          slug: 'entertainment',
          title: 'Entertainment',
        ),
      ],
    );
  }
  
  /// Create multiple master factors for testing
  static List<MasterFactorEntity> multipleFactors() {
    return [
      complete(),
      work(),
      relationships(),
      lifestyle(),
      minimal(slug: 'environment', title: 'Environment'),
    ];
  }
  
  /// Create factors with specific slugs for testing filtering
  static List<MasterFactorEntity> factorsWithSlugs(List<String> slugs) {
    return slugs.map((slug) {
      switch (slug) {
        case 'health':
          return complete(slug: 'health', title: 'Health');
        case 'work':
          return work();
        case 'relationships':
          return relationships();
        case 'lifestyle':
          return lifestyle();
        default:
          return minimal(slug: slug, title: slug.toUpperCase());
      }
    }).toList();
  }
  
  /// Create a list of subcategories for testing
  static List<SubCategoryEntity> subcategories() {
    return [
      SubCategoryEntity(slug: 'exercise', title: 'Exercise'),
      SubCategoryEntity(slug: 'nutrition', title: 'Nutrition'),
      SubCategoryEntity(slug: 'sleep', title: 'Sleep'),
      SubCategoryEntity(slug: 'meetings', title: 'Meetings'),
      SubCategoryEntity(slug: 'deadlines', title: 'Deadlines'),
      SubCategoryEntity(slug: 'family', title: 'Family'),
      SubCategoryEntity(slug: 'friends', title: 'Friends'),
    ];
  }
  
  /// Create subcategories with specific slugs
  static List<SubCategoryEntity> subcategoriesWithSlugs(List<String> slugs) {
    return slugs.map((slug) => SubCategoryEntity(
      slug: slug,
      title: _titleFromSlug(slug),
    )).toList();
  }
  
  /// Helper method to convert slug to title
  static String _titleFromSlug(String slug) {
    return slug
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

