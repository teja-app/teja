// lib/domain/entities/feeling.dart

import 'package:swayam/domain/entities/master_factor.dart';

class MasterFeelingEntity {
  final String slug;
  final String name;
  final String description;
  final int moodId;
  final List<MasterFactorEntity>? factors; // Include a list of factor entities

  MasterFeelingEntity({
    required this.slug,
    required this.name,
    required this.description,
    required this.moodId,
    this.factors = const [], // Default to an empty list if not provided
  });

  // CopyWith method for immutability
  MasterFeelingEntity copyWith({
    String? slug,
    String? name,
    String? description,
    int? moodId,
    List<MasterFactorEntity>? factors, // Changed to MasterFactorEntity
  }) {
    return MasterFeelingEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      moodId: moodId ?? this.moodId,
      factors: factors ?? this.factors,
    );
  }
}
