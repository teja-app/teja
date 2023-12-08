import 'package:flutter/material.dart';
import 'package:teja/domain/entities/vision_entity.dart';

@immutable
class LoadVisionsAction {}

@immutable
class VisionsLoadedAction {
  final List<VisionEntity> visions;

  const VisionsLoadedAction(this.visions);
}

@immutable
class VisionToggleAction {
  final String visionSlug;

  const VisionToggleAction(this.visionSlug);
}

@immutable
class VisionUpdateInProgressAction {}

@immutable
class VisionUpdateSuccessAction {
  final List<VisionEntity> visions;

  const VisionUpdateSuccessAction(this.visions);
}

@immutable
class VisionUpdateFailedAction {
  final String error;

  const VisionUpdateFailedAction(this.error);
}
