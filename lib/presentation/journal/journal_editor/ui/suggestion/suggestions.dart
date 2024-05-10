import 'package:flutter/material.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

Widget buildSuggestions(BuildContext context, List<String> suggestions) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return Expanded(
    child: ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return FlexibleHeightBox(
          gridWidth: 4,
          child: Flexible(
            child: SelectableText(
              suggestions[index],
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
        );
      },
    ),
  );
}
