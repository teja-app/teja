import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/profile/ui/data_check_overlay.dart';

class Checklist extends StatelessWidget {
  final Widget child;
  final String componentName;

  const Checklist({
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
        return Stack(
          children: [
            child,
            if (viewModel.requiredPermissions.isNotEmpty)
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

    return ChecklistViewModel(
      hasPermissions: hasPermissions,
      requiredPermissions: requiredPermissions,
    );
  }
}
