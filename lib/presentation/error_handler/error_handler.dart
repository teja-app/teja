import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:toastification/toastification.dart';

class ErrorHandler extends StatelessWidget {
  final Widget child;

  const ErrorHandler({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      onDidChange: (_, _ViewModel vm) {
        if (vm.latestError != null) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.flatColored,
            autoCloseDuration: const Duration(seconds: 5),
            title: Text(vm.latestError!.code),
            description: Text(vm.latestError!.message),
            alignment: Alignment.topRight,
            direction: TextDirection.ltr,
            animationDuration: const Duration(milliseconds: 300),
            icon: const Icon(Icons.error_outline),
            primaryColor: Colors.red,
            backgroundColor: Colors.red.shade100,
            foregroundColor: Colors.red.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            borderRadius: BorderRadius.circular(12),
            showProgressBar: true,
            closeButtonShowType: CloseButtonShowType.onHover,
            closeOnClick: false,
            pauseOnHover: true,
            dragToClose: true,
            callbacks: ToastificationCallbacks(
              onDismissed: (_) => vm.clearError(vm.latestError!),
            ),
          );
        }
      },
      builder: (BuildContext context, _ViewModel vm) {
        return child;
      },
    );
  }
}

class _ViewModel {
  final List<AppError> errors;
  final AppError? latestError;
  final Function(AppError) clearError;

  _ViewModel({required this.errors, this.latestError, required this.clearError});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      errors: store.state.appErrorState.errors,
      latestError: store.state.appErrorState.errors.isNotEmpty ? store.state.appErrorState.errors.last : null,
      clearError: (AppError error) {
        store.dispatch(ClearErrorAction(error));
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel && runtimeType == other.runtimeType && errors.length == other.errors.length;

  @override
  int get hashCode => errors.length.hashCode;
}
