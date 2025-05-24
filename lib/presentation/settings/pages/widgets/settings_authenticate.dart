import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void settingsAuthenticate(BuildContext context, VoidCallback onSuccess) async {
  final LocalAuthentication auth = LocalAuthentication();

  try {
    // Check if we have biometric authentication
    final bool canCheckBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    if (!canCheckBiometrics || availableBiometrics.isEmpty) {
      if (context.mounted) {
        showSnackbar(context, 'Biometric authentication not available or set up.');
      }
      return;
    }

    // Attempting biometric authentication
    final bool authenticated = await auth.authenticate(
      localizedReason: 'Authenticate to access advanced settings',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      onSuccess();
    } else {
      if (context.mounted) {
        showSnackbar(context, 'Authentication canceled by user.');
      }
    }
  } on PlatformException catch (e) {
    // Handling specific platform exceptions
    if (e.code == 'NotAvailable') {
      if (context.mounted) {
        showSnackbar(context, 'Biometric authentication not available.');
      }
    } else if (e.code == 'NotEnrolled') {
      if (context.mounted) {
        showSnackbar(context, 'No biometrics enrolled. Please set up biometric authentication.');
      }
    } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
      if (context.mounted) {
        showSnackbar(context, 'Biometric authentication is locked out. Please try again later.');
      }
    } else {
      if (context.mounted) {
        showSnackbar(context, 'Authentication error: ${e.message}');
      }
    }
  } catch (e) {
    // Generic error handling
    if (context.mounted) {
      showSnackbar(context, 'An unexpected error occurred. Please try again.');
    }
  }
}

// Helper function to show a Snackbar with a message
void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
