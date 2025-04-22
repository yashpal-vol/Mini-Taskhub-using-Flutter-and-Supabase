import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.title,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.teal),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}