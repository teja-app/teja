import 'dart:io';
import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/image_storage_helper.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart'; // Import the package

class AttachmentImage extends StatelessWidget {
  final String relativeImagePath;
  double? width;
  double? height;

  AttachmentImage({super.key, required this.relativeImagePath, this.height = 100, this.width = 100});

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to handle asynchronous operation
    return FutureBuilder<File>(
      future: ImageStorageHelper.getImage(relativeImagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // When the future completes with data
          final File imageFile = snapshot.data!;
          return InstaImageViewer(
            // Wrap the image with InstaImageViewer
            child: Container(
              margin: const EdgeInsets.all(4),
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle the error state
          return Container(
            margin: const EdgeInsets.all(4),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.error, color: Colors.red),
          );
        } else {
          // Handle the loading state
          return Container(
            margin: const EdgeInsets.all(4),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
