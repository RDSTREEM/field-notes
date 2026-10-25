import 'package:flutter/material.dart';

import "../data/notes_repo.dart";
import "../models/notes.dart";
import "add_screen.dart";
import "../colors.dart";

class DetailsScreen extends StatefulWidget {
  final Notes note;

  const DetailsScreen({super.key, required this.note});

  @override
  State<DetailsScreen> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  late Notes note;

  @override
  void initState() {
    super.initState();

    note = widget.note;
  }

  String get date {
    final d = note.createdAt.toLocal();

    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${months[d.month - 1]} ${d.day} ${d.year}";
  }

  Future<void> edit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddScreen(note: note)),
    );

    if (!mounted || saved != true) return;

    final updated = await NotesRepo.instance.getById(note.id);

    if (updated != null) {
      setState(() {
        note = updated;
      });
    }
  }

  Future<void> delete() async {
    final confirmed = await showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text("This note will be permanently deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(dContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await NotesRepo.instance.delete(note.id);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not delete the note")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: forest,
      appBar: AppBar(
        backgroundColor: paper,
        title: Text("Field Journal"),
        actions: [
          IconButton(
            tooltip: "Edit Note",
            onPressed: edit,
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: delete,
            icon: Icon(Icons.delete_outline),
            tooltip: "Delete Note",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: forest.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                child: Text(
                  note.category.toUpperCase(),
                  style: const TextStyle(
                    color: forest,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: muted),
              const SizedBox(width: 8),
              Text(date, style: const TextStyle(color: muted, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
