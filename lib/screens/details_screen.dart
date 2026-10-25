import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";

import "dart:io";

import "../data/notes_repo.dart";
import "../models/notes.dart";
import "add_screen.dart";

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

    return "${months[d.month - 1]} ${d.day}, ${d.year}";
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

  Future<void> openMap() async {
    final latitude = note.latitude;
    final longitude = note.longitude;

    if (latitude == null || longitude == null) return;

    final url = Uri.https("www.google.com", "/maps/search", {
      "api": "1",
      "query": "$latitude,$longitude",
    });

    try {
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Could not open maps")));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Could not open maps")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasLocation = note.latitude != null && note.longitude != null;
    final hasImage =
        note.imagePath != null && File(note.imagePath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Journal'),
        actions: [
          IconButton(
            tooltip: 'Edit Note',
            onPressed: edit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete Note',
            onPressed: delete,
            icon: const Icon(Icons.delete_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 14,
                ),
                child: Text(
                  note.category.toUpperCase(),
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            note.title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 32,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: colors.onSurface.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'FIELD NOTES',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          if (hasImage) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(File(note.imagePath!), fit: BoxFit.cover),
            ),
            const SizedBox(height: 18),
          ],
          Text(
            note.notes.isEmpty
                ? 'No notes were recorded for this one.'
                : note.notes,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          if (hasLocation) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: openMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Open in Maps'),
            ),
            const SizedBox(height: 8),
            Text(
              '${note.latitude!.toStringAsFixed(5)}, '
              '${note.longitude!.toStringAsFixed(5)}',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.65),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
