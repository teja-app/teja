// lib/domain/entities/master_feeling_entity.dart
class MasterFeelingEntity {
  final int? id;
  final String name;
  final String slug;
  final String? parentSlug; // Optional, used for subcategories and feelings
  final String type; // Can be 'category', 'subcategory', or 'feeling'
  final int? energy; // Optional, specific to 'feeling' type
  final int? pleasantness; // Optional, specific to 'feeling' type

  MasterFeelingEntity({
    required this.name,
    required this.slug,
    required this.type,
    this.parentSlug,
    this.energy,
    this.pleasantness,
    this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MasterFeelingEntity &&
        other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.parentSlug == parentSlug &&
        other.type == type &&
        other.energy == energy &&
        other.pleasantness == pleasantness;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        slug.hashCode ^
        parentSlug.hashCode ^
        type.hashCode ^
        energy.hashCode ^
        pleasantness.hashCode;
  }

  // CopyWith method for immutability
  MasterFeelingEntity copyWith({
    int? id,
    String? name,
    String? slug,
    String? parentSlug,
    String? type,
    int? energy,
    int? pleasantness,
  }) {
    return MasterFeelingEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      parentSlug: parentSlug ?? this.parentSlug,
      type: type ?? this.type,
      energy: energy ?? this.energy,
      pleasantness: pleasantness ?? this.pleasantness,
    );
  }
}
