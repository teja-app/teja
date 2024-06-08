import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/domain/redux/constants/checklist_strings.dart';

class DataCheckOverlay extends StatelessWidget {
  final List<Map<String, bool>> checklist;

  static List<Map<String, String>> labels = [
    {
      SLEEP_DATA: 'Enable sleep tracking to view sleep data.',
    },
    {
      MOOD_DATA: 'Add mood data to view mood data.',
    },
  ];

  const DataCheckOverlay({Key? key, required this.checklist}) : super(key: key);

  void _handleIconTap(BuildContext context, String key) {
    if (key == SLEEP_DATA) {
      if (!checklist
          .firstWhere((item) => item.containsKey('Sleep data exists'))
          .values
          .first) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Either the sleep data is not enabled or data does not exist.'),
          ),
        );
      }
    } else if (key == MOOD_DATA) {
      GoRouter.of(context).push("/mood_edit");
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
            ...checklist.map((item) {
              final entry = item.entries.first;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    labels
                        .firstWhere(
                            (element) => element.keys.first == entry.key)
                        .values
                        .first,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _handleIconTap(context, entry.key),
                    child: Icon(
                      entry.value ? Icons.check_circle : Icons.error,
                      color: entry.value ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
    // );
  }
}
