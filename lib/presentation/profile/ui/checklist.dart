import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/mood/share/ui/Share_option_popup.dart';
import 'package:teja/presentation/profile/ui/data_check_overlay.dart';

class Checklist extends StatelessWidget {
  final Widget child;
  final String componentName;
  final GlobalKey globalKey = GlobalKey();

  Checklist({
    Key? key,
    required this.child,
    required this.componentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChecklistViewModel>(
      converter: (store) {
        final viewModel = ChecklistViewModel.fromStore(store, componentName);
        return viewModel;
      },
      builder: (context, viewModel) {
        final allPermissionsGranted = viewModel.requiredPermissions.every(
            (permission) => viewModel.hasPermissions.contains(permission));

        return Stack(
          children: [
            ClipRect(
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  child: child,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 8,
              child: ShareOptionsPopup(globalKey: globalKey),
            ),
            if (!allPermissionsGranted)
              Positioned.fill(
                child: DataCheckOverlay(
                  hasPermissions: viewModel.hasPermissions,
                  requiredPermissions: viewModel.requiredPermissions,
                ),
              ),
          ],
        );
      },
    );
  }
}

// // ChecklistViewModel remains the same
class ChecklistViewModel {
  final List<String> hasPermissions;
  final List<String> requiredPermissions;

  ChecklistViewModel({
    required this.hasPermissions,
    required this.requiredPermissions,
  });

  factory ChecklistViewModel.fromStore(
      Store<AppState> store, String componentName) {
    final hasPermissions = store.state.permissionState.hasPermissions;
    final requiredPermissions = featureChecklist[componentName] ?? [];

    print('hasPermissions: $hasPermissions');
    print('requiredPermissions: $requiredPermissions');

    return ChecklistViewModel(
      hasPermissions: hasPermissions,
      requiredPermissions: requiredPermissions,
    );
  }
}
