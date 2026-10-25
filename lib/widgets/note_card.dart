import "package:flutter/material.dart";

import "../colors.dart";
import "../models/notes.dart";

// import "../screens/details_screen.dart";

class NoteCard extends StatelessWidget {
  final Notes note;
  final VoidCallback tap;

  const NoteCard({super.key, required this.note, required this.tap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: paper,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
        side: const BorderSide(color: Color(0xFFE8E5DA)),
      ),
      child: ListTile(
        /* onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailsScreen(note: note)),
          );
        }, */
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: paper,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.spa_outlined, color: forest),
        ),
        title: Text(
          note.title,
          style: const TextStyle(color: forest, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '${note.category} ${note.createdAt}'
            '${note.notes.isEmpty ? '' : '\n ${note.notes}'}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
