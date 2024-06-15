import 'package:flutter/material.dart';

@immutable
abstract class PermissionAction {}

@immutable
class AddPermissionAction extends PermissionAction {
  final String permission;

  AddPermissionAction(this.permission);
}

@immutable
class AddPermissionActionSuccess extends PermissionAction {
  final List<String> updatedPermissions;

  AddPermissionActionSuccess(this.updatedPermissions);
}
