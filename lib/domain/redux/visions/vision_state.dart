import 'package:flutter/foundation.dart';
import 'package:teja/domain/entities/vision_entity.dart';

@immutable
class VisionState {
  final List<VisionEntity> visions;
  final bool isLoading;
  final String? errorMessage;

  const VisionState({
    required this.visions,
    this.isLoading = false,
    this.errorMessage,
  });

  factory VisionState.initial() {
    return const VisionState(
      visions: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  VisionState copyWith({
    List<VisionEntity>? visions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return VisionState(
      visions: visions ?? this.visions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'VisionState(visions: $visions, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
