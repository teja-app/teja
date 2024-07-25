import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/onboarding/widgets/feature_bottom_sheet.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class FeatureGate extends StatefulWidget {
  final String feature;
  final Widget child;
  final FeatureTab initialTab; // Added parameter for tab selection
  final VoidCallback? onFeatureAccessed; // Optional callback
  final bool autoTriggerOnAccess; // Flag to control auto-trigger

  FeatureGate({
    Key? key,
    required this.feature,
    this.initialTab = FeatureTab.free,
    required this.child,
    this.onFeatureAccessed, // Optional callback
    this.autoTriggerOnAccess = false, // Default to false
  }) : super(key: key);

  @override
  _FeatureGateState createState() => _FeatureGateState();
}

class _FeatureGateState extends State<FeatureGate> {
  final SecureStorage _secureStorage = SecureStorage();
  bool _hasTriggered = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Future<FeatureGateViewModel>>(
        converter: (store) {
      return FeatureGateViewModel.fromStore(
          store, widget.feature, _secureStorage);
    }, builder: (context, futureViewModel) {
      return FutureBuilder<FeatureGateViewModel>(
        future: futureViewModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.hasAccess) {
            // Conditionally trigger onFeatureAccessed callback
            if (widget.autoTriggerOnAccess &&
                widget.onFeatureAccessed != null &&
                !_hasTriggered &&
                snapshot.data!.hasAccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onFeatureAccessed!();
                setState(() {
                  _hasTriggered = true;
                });
              });
            }

            return widget.child;
          } else {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AbsorbPointer(
                  absorbing: true,
                  child: Opacity(
                    opacity: 0.5, // You can adjust the opacity as needed
                    child: widget.child,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.lock, color: Colors.white, size: 24),
                  onPressed: () => _showFeatureBottomSheet(context),
                ),
              ],
            );
          }
        },
      );
    });
  }

  void _showFeatureBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FeatureAccessBottomSheet(
          initialTab: widget.initialTab, // Pass the tab parameter here
        );
      },
    );
  }
}

class FeatureGateViewModel {
  final bool hasAccess;

  FeatureGateViewModel({required this.hasAccess});

  static Future<FeatureGateViewModel> fromStore(
    Store<AppState> store,
    String feature,
    SecureStorage secureStorage,
  ) async {
    try {
      final accessDetails = await secureStorage.readAccessDetails();
      print('Access details: $accessDetails'); // Debug print
      final hasAccess = accessDetails?.contains(feature) ?? false;
      print('Has access: $hasAccess'); // Debug print
      return FeatureGateViewModel(hasAccess: hasAccess);
    } catch (e) {
      print('Error fetching access details: $e'); // Debug print
      return FeatureGateViewModel(
          hasAccess: false); // Default to no access on error
    }
  }
}
