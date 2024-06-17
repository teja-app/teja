// lib/domain/redux/permission/permission_reducer.dart
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/permission/permission_actions.dart';
import 'package:teja/domain/redux/permission/permission_state.dart';

Reducer<PermissionState> permissionReducer = combineReducers([
  TypedReducer<PermissionState, AddPermissionAction>(_addPermission),
]);

PermissionState _addPermission(
    PermissionState state, AddPermissionAction action) {
  final updatedPermissions = List<String>.from(state.hasPermissions);
  if (!updatedPermissions.contains(action.permission)) {
    updatedPermissions.add(action.permission);
  }

  return state.copyWith(hasPermissions: updatedPermissions);
}
