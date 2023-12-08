import 'package:flutter/material.dart';

class Vision {
  final IconData iconData;
  final String title;
  final String description;
  bool isSelected;
  int? order;
  final String slug;

  Vision({
    required this.iconData,
    required this.title,
    required this.description,
    required this.slug,
    this.isSelected = false,
    this.order,
  });

  Vision copyWith({
    IconData? iconData,
    String? title,
    String? description,
    bool? isSelected,
    int? order,
    String? slug,
  }) {
    return Vision(
      iconData: iconData ?? this.iconData,
      title: title ?? this.title,
      description: description ?? this.description,
      slug: slug ?? this.slug,
      isSelected: isSelected ?? this.isSelected,
      order: order ?? this.order,
    );
  }
}

class VisionCard extends StatelessWidget {
  final Vision vision;
  final VoidCallback onTap;

  const VisionCard({
    Key? key,
    required this.vision,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    return Card(
      color: vision.isSelected ? colorSchema.surface : colorSchema.background, // Change color to indicate selection
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                vision.iconData,
                size: 48,
                color: vision.isSelected ? colorSchema.background : colorSchema.surface,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vision.title,
                      style: TextStyle(
                        color: vision.isSelected ? colorSchema.background : colorSchema.surface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vision.description,
                      style: TextStyle(
                        color: vision.isSelected ? colorSchema.background : colorSchema.surface,
                      ),
                    ),
                  ],
                ),
              ),
              if (vision.order != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    vision.order.toString(),
                    style: TextStyle(
                      color: colorSchema.background,
                      fontSize: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
