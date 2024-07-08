import 'package:flutter/material.dart';
import 'package:teja/presentation/registration/ui/RecoveryCodeDisplay.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class RecoveryCodePage extends StatelessWidget {
  final SecureStorage secureStorage = SecureStorage();

  RecoveryCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery Codes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<String?>(
        future: secureStorage.readRecoveryCode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recovery code available.'));
          } else {
            return RecoveryCodeDisplay(recoveryCode: snapshot.data!);
          }
        },
      ),
    );
  }
}
