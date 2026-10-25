import 'package:flutter/material.dart';

import '../models/notes.dart';

class NoteCard extends StatelessWidget {
  final Notes note;
  final VoidCallback tap;

  const NoteCard({super.key, required this.note, required this.tap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: tap,
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(Icons.spa_outlined, color: colors.primary),
        ),
        title: Text(
          note.title,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '${note.category} · ${note.createdAt.toLocal()}'
            '${note.notes.isEmpty ? '' : '\n${note.notes}'}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: colors.onSurface.withValues(alpha: 0.75)),
          ),
        ),
      ),
    );
  }
}
