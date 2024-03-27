import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:teja/router.dart';

void authenticate(BuildContext context, VoidCallback onSuccess) async {
  final LocalAuthentication auth = LocalAuthentication();

  try {
    // Check if we have biometric authentication
    final bool canCheckBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    if (!canCheckBiometrics || availableBiometrics.isEmpty) {
      _showSnackbar(context, 'Biometric authentication not available or set up.');
      return;
    }

    // Attempting biometric authentication
    final bool authenticated = await auth.authenticate(
      localizedReason: 'Authenticate to start your journey towards a balanced life',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      onSuccess(); // Trigger the callback if authenticated

      Future.delayed(const Duration(seconds: 3), () {
        GoRouter.of(context).replaceNamed(RootPath.home);
      });
    } else {
      _showSnackbar(context, 'Authentication canceled by user.');
    }
  } on PlatformException catch (e) {
    // Handling specific platform exceptions
    if (e.code == 'NotAvailable') {
      _showSnackbar(context, 'Biometric authentication not available.');
    } else if (e.code == 'NotEnrolled') {
      _showSnackbar(context, 'No biometrics enrolled. Please set up biometric authentication.');
    } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
      _showSnackbar(context, 'Biometric authentication is locked out. Please try again later.');
    } else {
      _showSnackbar(context, 'Authentication error: ${e.message}');
    }
  } catch (e) {
    // Generic error handling
    _showSnackbar(context, 'An unexpected error occurred. Please try again.');
  }
}

// Helper function to show a Snackbar with a message
void _showSnackbar(BuildContext context, String message) {
  print("message ${message}");
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
