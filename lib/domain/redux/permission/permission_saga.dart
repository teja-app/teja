// lib/domain/redux/permission/permission_saga.dart
import 'package:redux/redux.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/permission/permission_actions.dart';

class PermissionSaga {
  final Store<AppState> store;

  PermissionSaga(this.store);

  Iterable<void> saga() sync* {
    yield TakeEvery(_handleAddPermission, pattern: AddPermissionAction);
    // Add more take patterns for other permission-related actions, if needed
  }

  _handleAddPermission({required AddPermissionAction action}) sync* {
    yield Try(() sync* {
      final currentPermissions =
          List<String>.from(store.state.permissionState.hasPermissions);
      // Check if the permission already exists
      if (!currentPermissions.contains(action.permission)) {
        currentPermissions.add(action.permission);
        yield Put(AddPermissionActionSuccess(currentPermissions));
      }
    }, Catch: (e, s) sync* {
      // Handle any errors that occurred during the saga
      print('Error adding permission: $e');
    });
  }
}
