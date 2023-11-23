import 'package:flutter/material.dart';

class DescriptionButton extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon; // Optional icon data
  final double maxWidth; // Maximum width for the card
  final VoidCallback onPressed; // Callback for when the button is pressed

  const DescriptionButton({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
    this.icon, // Optional icon parameter
    this.maxWidth = 300.0, // Default max width to 300.0 pixels
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate width based on the screen size to be responsive
    double cardWidth = screenWidth > maxWidth ? maxWidth : screenWidth - 16.0;

    // Wrap the entire Container with an InkWell to make it tappable
    return InkWell(
      onTap: onPressed, // Call the onPressed callback when the button is tapped
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the card
          border: Border.all(
            color: Colors.black, // Border color similar to secondaryButton
            width: 1, // Border width
          ),
          borderRadius:
              BorderRadius.circular(8), // Rounded corners like the button
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // If an icon is provided, display it next to the title
              if (icon != null)
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 16.0,
                      color: Colors.black,
                    ), // Display the icon
                    const SizedBox(
                        width: 8.0), // Spacing between the icon and the title
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              // If no icon is provided, just display the title
              if (icon == null)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              const SizedBox(height: 10.0),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
