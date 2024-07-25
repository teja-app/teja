import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

class JournalMenuSettings extends StatelessWidget {
  final String journalId;
  final Function onDelete;
  final Function onEdit;

  const JournalMenuSettings({
    Key? key,
    required this.journalId,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      key: const Key("journal_settings"),
      icon: const Icon(
        AntDesign.ellipsis1,
        size: 16,
      ),
      onSelected: (int result) {
        if (result == 0) {
          onEdit();
        } else if (result == 1) {
          onDelete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        // const PopupMenuItem<int>(
        //   value: 0,
        //   child: Text('Edit'),
        // ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
