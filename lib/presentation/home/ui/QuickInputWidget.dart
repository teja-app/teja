import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

class QuickInputWidget extends StatelessWidget {
  final VoidCallback onTap;

  const QuickInputWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // IconButton(
            //   icon: const Icon(AntDesign.camera, color: Colors.lightBlue),
            //   onPressed: () {
            //     // Handle camera button press
            //   },
            // ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'What on your mind?...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                readOnly: true,
                onTap: onTap,
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.mic, color: Colors.grey),
            //   onPressed: () {
            //     // Handle mic button press
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(AntDesign.picture, color: Colors.grey),
            //   onPressed: () {
            //     // Handle image button press
            //   },
            // ),
            IconButton(
              icon: const Icon(Foundation.pencil, color: Colors.black),
              onPressed: () {
                // Handle add button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
