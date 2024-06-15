// lib/domain/redux/permission/permission_reducer.dart
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/permission/permission_actions.dart';
import 'package:teja/domain/redux/permission/permission_state.dart';

Reducer<PermissionState> permissionReducer = combineReducers([
  TypedReducer<PermissionState, AddPermissionAction>(_addPermission),
  TypedReducer<PermissionState, AddPermissionActionSuccess>(_updatePermissions),
]);

PermissionState _addPermission(
    PermissionState state, AddPermissionAction action) {
  final updatedPermissions = [...state.hasPermissions, action.permission];
  return state.copyWith(hasPermissions: updatedPermissions);
}

PermissionState _updatePermissions(
    PermissionState state, AddPermissionActionSuccess action) {
  print('action.updatedPermissions: ${action.updatedPermissions}');
  return state.copyWith(hasPermissions: action.updatedPermissions);
}
