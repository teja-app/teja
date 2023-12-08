import 'package:flutter/material.dart';

@immutable
class VisionEntity {
  final String slug;
  final int order;

  const VisionEntity({
    required this.slug,
    required this.order,
  });

  @override
  String toString() => 'VisionEntity(slug: $slug, order: $order)';
}
