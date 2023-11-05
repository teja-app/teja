import 'package:flutter/material.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  void _exportData(BuildContext context) {
    // Implement data export logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your data will be sent to your email shortly.'),
      ),
    );
  }

  void _deactivateAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deactivate Account'),
          content:
              const Text('Are you sure you want to deactivate your account?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deactivate'),
              onPressed: () {
                // Implement account deactivation logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Implement account deletion logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reactivatePurchase(BuildContext context) {
    // Implement purchase reactivation logic here
  }

  void _reportStolenAccount(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Stolen Account'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Last Login Date',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the last date you were able to login';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Additional Information',
                  ),
                  maxLines: 3, // Allow multiple lines of input
                  validator: (value) {
                    return null;
                  
                    // Optionally validate other information
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Implement reporting logic here
                  // e.g., send the information to your server
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Report submitted. We will contact you shortly.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500) ? 500 : screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Settings'),
      ),
      body: Center(
        child: Container(
          width: contentWidth,
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                title: const Text('Export Data'),
                trailing: IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () => _exportData(context),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Deactivate Account'),
                trailing: IconButton(
                  icon: const Icon(Icons.pause_circle_outline),
                  onPressed: () => _deactivateAccount(context),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Delete Account'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteAccount(context),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Reactivate Purchase'),
                trailing: ElevatedButton(
                  onPressed: () => _reactivatePurchase(context),
                  child: const Text('Reactivate'),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Report Stolen Account'),
                trailing: IconButton(
                  icon: const Icon(Icons.report_problem),
                  onPressed: () => _reportStolenAccount(context),
                ),
              ),
              // ... add more advanced settings here
            ],
          ),
        ),
      ),
    );
  }
}
