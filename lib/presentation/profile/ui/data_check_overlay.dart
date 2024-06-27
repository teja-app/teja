import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';

class DataCheckOverlay extends StatelessWidget {
  final List<String> hasPermissions;
  final List<String> requiredPermissions;

  const DataCheckOverlay({
    Key? key,
    required this.hasPermissions,
    required this.requiredPermissions,
  }) : super(key: key);

  void _handleIconTap(BuildContext context, String permission) {
    if (permission == SLEEP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Either the sleep data is not enabled or data does not exist.'),
        ),
      );
    } else if (permission == MOOD_MONTHLY) {
      GoRouter.of(context).push("/mood_edit");
    } else if (permission == PREMIUM) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('You need to be a premium user to access this feature.'),
        ),
      );
    } else if (permission == ACTIVITY_MONTHLY) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Either the activity data is not enabled or data does not exist.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background.withOpacity(0.9),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Missing Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...requiredPermissions.map((permission) {
              final hasPermission = hasPermissions.contains(permission);
              final label = labels.firstWhere(
                (element) => element.keys.first == permission,
                orElse: () => {permission: ''},
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label.values.first,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _handleIconTap(context, permission),
                      child: Icon(
                        hasPermission ? Icons.check_circle : Icons.error,
                        color: hasPermission ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
