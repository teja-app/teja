import 'package:flutter/material.dart';

class SecuritySettingsPage extends StatefulWidget {
  @override
  _SecuritySettingsPageState createState() => _SecuritySettingsPageState();
}

// Define the authentication methods
enum AuthMethod {
  none,
  faceID,
  passcode,
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _isPremiumUser = true; // Assume not a premium user initially
  AuthMethod _selectedAuthMethod =
      AuthMethod.none; // Initially, no method is selected

  void _changePassword() {
    // Logic to trigger a password reset email
  }

  void _toggleTwoFactorAuthentication(bool value) {
    setState(() {
      _isPremiumUser = value;
    });
    if (value) {
      // Logic to enable two-factor authentication
    } else {
      // Logic to disable two-factor authentication
    }
  }

  void _updateAuthMethod(AuthMethod method) {
    setState(() {
      _selectedAuthMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500) ? 500 : screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Security Settings'),
      ),
      body: Center(
        child: Container(
          width: contentWidth,
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                title: Text('Change Password'),
                subtitle: Text('Trigger a password reset email'),
                trailing: IconButton(
                  icon: Icon(Icons.email),
                  onPressed: _changePassword,
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Two-Factor Authentication'),
                subtitle: Text(_isPremiumUser
                    ? 'Enabled with custom passcode'
                    : 'Upgrade to premium to enable'),
                trailing: Switch(
                  value: _isPremiumUser,
                  onChanged:
                      _isPremiumUser ? _toggleTwoFactorAuthentication : null,
                ),
              ),
              if (_isPremiumUser) ...[
                ListTile(
                  title: Text('Face ID'),
                  trailing: Radio(
                    value: AuthMethod.faceID,
                    groupValue: _selectedAuthMethod,
                    onChanged: (AuthMethod? value) {
                      if (value != null) _updateAuthMethod(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text('Passcode'),
                  trailing: Radio(
                    value: AuthMethod.passcode,
                    groupValue: _selectedAuthMethod,
                    onChanged: (AuthMethod? value) {
                      if (value != null) _updateAuthMethod(value);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
