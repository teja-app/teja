import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/shared/common/button.dart';

class RecoveryCodeDisplay extends StatelessWidget {
  final String recoveryCode;

  const RecoveryCodeDisplay({Key? key, required this.recoveryCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(AntDesign.key, size: 30),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'These words are the keys to your data',
                style: textTheme.bodyLarge,
              ),
            ),
            Center(
              child: Text(
                'Please write them down or store it somewhere safe',
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
              ),
              itemCount: recoveryCode.split(' ').length,
              itemBuilder: (context, index) {
                final words = recoveryCode.split(' ');
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 15,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('${index + 1}', style: textTheme.bodySmall),
                    ),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        words[index],
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Store recovery phrase securely. '
              'Do not share it. '
              'Anyone with these words will have full access to your account. '
              'Losing it means losing your Teja account.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Center(
              child: Button(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: recoveryCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mnemonic copied to clipboard')),
                  );
                },
                icon: AntDesign.copy1,
                text: 'Copy to Clipboard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
