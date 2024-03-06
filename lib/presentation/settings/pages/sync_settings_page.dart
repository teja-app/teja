import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/sync/actions.dart';

class SyncSettingsPage extends StatefulWidget {
  const SyncSettingsPage({super.key});

  @override
  SyncSettingsPageState createState() => SyncSettingsPageState();
}

class SyncSettingsPageState extends State<SyncSettingsPage> {
  Widget _importJson(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return ListTile(
          title: const Text('Restore from Backup'),
          onTap: () {
            store.dispatch(const ImportJSONAction());
          },
        );
      },
    );
  }

  Widget _exportJson(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return ListTile(
          title: const Text('Export Data'),
          onTap: () {
            store.dispatch(const ExportJSONAction());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500) ? 500 : screenWidth;

    return StoreConnector<AppState, ViewModel>(
      converter: ViewModel.fromStore,
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Backup and Restore'),
          ),
          body: Center(
            child: Container(
              width: contentWidth,
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _importJson(context),
                  // ListTile(
                  //   title: const Text('Change Password'),
                  //   subtitle: const Text('Trigger a password reset email'),
                  //   trailing: IconButton(
                  //     icon: const Icon(Icons.email),
                  //     onPressed: _changePassword,
                  //   ),
                  // ),
                  const Divider(),
                  _exportJson(context),
                  // ListTile(
                  //   title: const Text('Two-Factor Authentication'),
                  //   subtitle: Text(_isPremiumUser ? 'Enabled with custom passcode' : 'Upgrade to premium to enable'),
                  //   trailing: Switch(
                  //     value: _isPremiumUser,
                  //     onChanged: _isPremiumUser ? _toggleTwoFactorAuthentication : null,
                  //   ),
                  // ),
                  // if (_isPremiumUser) ...[
                  //   ListTile(
                  //     title: const Text('Face ID'),
                  //     trailing: Radio(
                  //       value: AuthMethod.faceID,
                  //       groupValue: _selectedAuthMethod,
                  //       onChanged: (AuthMethod? value) {
                  //         if (value != null) _updateAuthMethod(value);
                  //       },
                  //     ),
                  //   ),
                  //   ListTile(
                  //     title: const Text('Passcode'),
                  //     trailing: Radio(
                  //       value: AuthMethod.passcode,
                  //       groupValue: _selectedAuthMethod,
                  //       onChanged: (AuthMethod? value) {
                  //         if (value != null) _updateAuthMethod(value);
                  //       },
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ViewModel {
  ViewModel();

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel();
  }
}
