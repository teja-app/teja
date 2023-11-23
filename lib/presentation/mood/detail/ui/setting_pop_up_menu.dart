import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

class SettingsPopupMenu extends StatelessWidget {
  final String moodId;
  final Function onDelete;

  const SettingsPopupMenu({
    Key? key,
    required this.moodId,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      key: const Key("mood_settings"),
      icon: const Icon(
        AntDesign.ellipsis1,
        size: 16,
      ),
      onSelected: (int result) {
        if (result == 0) {
          // Handle edit action
        } else if (result == 1) {
          onDelete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Text('Edit'),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
