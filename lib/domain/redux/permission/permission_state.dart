// lib/domain/redux/permission/permission_state.dart
import 'package:flutter/material.dart';

@immutable
class PermissionState {
  final List<String> hasPermissions;

  const PermissionState({this.hasPermissions = const []});

  factory PermissionState.initial() {
    return const PermissionState(hasPermissions: []);
  }

  PermissionState copyWith({List<String>? hasPermissions}) {
    return PermissionState(
        hasPermissions: hasPermissions ?? this.hasPermissions);
  }
}
