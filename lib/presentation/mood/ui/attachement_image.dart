import 'dart:io';

import 'package:flutter/material.dart';

class AttachmentImage extends StatelessWidget {
  final String imagePath;

  const AttachmentImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4), // Adjust spacing as needed
      width: 100, // Adjust size as needed
      height: 100, // Adjust size as needed
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(imagePath)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8), // Optional: if you want rounded corners
      ),
    );
  }
}
