import 'package:uuid/uuid.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';

class MasterFeelingFixtures {
  static const _uuid = Uuid();

  static MasterFeelingEntity category({
    String? id,
    String? name,
    String? slug,
  }) {
    return MasterFeelingEntity(
      id: id ?? 'category-${_uuid.v4()}',
      name: name ?? 'Positive',
      slug: slug ?? 'positive',
      type: 'category',
    );
  }

  static MasterFeelingEntity subcategory({
    String? id,
    String? name,
    String? slug,
    String? parentSlug,
  }) {
    return MasterFeelingEntity(
      id: id ?? 'subcategory-${_uuid.v4()}',
      name: name ?? 'Joy',
      slug: slug ?? 'joy',
      type: 'subcategory',
      parentSlug: parentSlug ?? 'positive',
    );
  }

  static MasterFeelingEntity feeling({
    String? id,
    String? name,
    String? slug,
    String? parentSlug,
    int? energy,
    int? pleasantness,
  }) {
    return MasterFeelingEntity(
      id: id ?? 'feeling-${_uuid.v4()}',
      name: name ?? 'Happy',
      slug: slug ?? 'happy',
      type: 'feeling',
      parentSlug: parentSlug ?? 'joy',
      energy: energy ?? 7,
      pleasantness: pleasantness ?? 8,
    );
  }

  static MasterFeelingEntity minimal({
    String? id,
    String? name,
    String? slug,
    String? type,
  }) {
    return MasterFeelingEntity(
      id: id ?? 'minimal-${_uuid.v4()}',
      name: name ?? 'Basic',
      slug: slug ?? 'basic',
      type: type ?? 'feeling',
    );
  }

  static List<MasterFeelingEntity> hierarchical() {
    final categoryId = 'category-${_uuid.v4()}';
    final subcategoryId = 'subcategory-${_uuid.v4()}';
    
    return [
      MasterFeelingEntity(
        id: categoryId,
        name: 'Positive',
        slug: 'positive',
        type: 'category',
      ),
      MasterFeelingEntity(
        id: subcategoryId,
        name: 'Joy',
        slug: 'joy',
        type: 'subcategory',
        parentSlug: 'positive',
      ),
      MasterFeelingEntity(
        id: 'feeling-${_uuid.v4()}',
        name: 'Happy',
        slug: 'happy',
        type: 'feeling',
        parentSlug: 'joy',
        energy: 7,
        pleasantness: 8,
      ),
      MasterFeelingEntity(
        id: 'feeling-${_uuid.v4()}',
        name: 'Excited',
        slug: 'excited',
        type: 'feeling',
        parentSlug: 'joy',
        energy: 9,
        pleasantness: 9,
      ),
    ];
  }

  static List<MasterFeelingEntity> feelingsOnly({int count = 5}) {
    return List.generate(count, (index) => feeling(
      id: 'feeling-${index + 1}',
      name: 'Feeling ${index + 1}',
      slug: 'feeling-${index + 1}',
      energy: (index % 10) + 1,
      pleasantness: ((index + 3) % 10) + 1,
    ));
  }

  static List<MasterFeelingEntity> mixedTypes() {
    return [
      category(name: 'Positive', slug: 'positive'),
      category(name: 'Negative', slug: 'negative'),
      subcategory(name: 'Joy', slug: 'joy', parentSlug: 'positive'),
      subcategory(name: 'Sadness', slug: 'sadness', parentSlug: 'negative'),
      feeling(name: 'Happy', slug: 'happy', parentSlug: 'joy', energy: 7, pleasantness: 8),
      feeling(name: 'Sad', slug: 'sad', parentSlug: 'sadness', energy: 2, pleasantness: 1),
    ];
  }
}