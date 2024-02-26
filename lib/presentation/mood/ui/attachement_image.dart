import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/image_storage_helper.dart';

class AttachmentImage extends StatelessWidget {
  final String relativeImagePath;

  const AttachmentImage({Key? key, required this.relativeImagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to handle asynchronous operation
    return FutureBuilder<File>(
      future: ImageStorageHelper.getImage(relativeImagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // When the future completes with data
          final File imageFile = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(4), // Adjust spacing as needed
            width: 100, // Adjust size as needed
            height: 100, // Adjust size as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8), // Optional: if you want rounded corners
            ),
          );
        } else if (snapshot.hasError) {
          // When the future completes with an error
          return Container(
            margin: const EdgeInsets.all(4),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Show a placeholder color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.error, color: Colors.red), // Indicate an error
          );
        } else {
          // While the future is still loading
          return Container(
            margin: const EdgeInsets.all(4),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Show a placeholder color
              borderRadius: BorderRadius.circular(8),
            ),
            child: const CircularProgressIndicator(), // Show a loading indicator
          );
        }
      },
    );
  }
}
