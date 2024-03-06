import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

class SettingsPopupMenu extends StatelessWidget {
  final String moodId;
  final Function onDelete;
  final Function onEdit;
  final Function onShare;

  const SettingsPopupMenu({
    Key? key,
    required this.moodId,
    required this.onDelete,
    required this.onEdit,
    required this.onShare,
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
          onEdit();
        } else if (result == 1) {
          onShare();
        } else if (result == 2) {
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
          child: Text('Share'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
