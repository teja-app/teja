// lib/domain/entities/feeling.dart

import 'package:swayam/domain/entities/master_factor.dart';

class MasterFeelingEntity {
  final int? id;
  final String slug;
  final String name;
  final String description;
  final int moodId;
  final List<MasterFactorEntity>? factors;

  MasterFeelingEntity({
    required this.slug,
    required this.name,
    required this.description,
    required this.moodId,
    this.factors = const [],
    this.id,
  });

  // CopyWith method for immutability
  MasterFeelingEntity copyWith({
    String? slug,
    String? name,
    String? description,
    int? moodId,
    List<MasterFactorEntity>? factors,
    int? id,
  }) {
    return MasterFeelingEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      moodId: moodId ?? this.moodId,
      factors: factors ?? this.factors,
      id: id ?? this.id,
    );
  }
}
