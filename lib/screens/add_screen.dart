import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

import '../models/notes.dart';
import "../colors.dart";
import "../data/notes_repo.dart";
import "../models/category.dart";

class AddScreen extends StatefulWidget {
  final Notes? note;

  const AddScreen({super.key, this.note});

  @override
  State<AddScreen> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  late String category;

  @override
  void initState() {
    super.initState();

    final note = widget.note;

    titleController.text = note?.title ?? '';
    notesController.text = note?.notes ?? '';
    category = note?.category ?? "Nature";
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    if (!formKey.currentState!.validate()) return;

    final existing = widget.note;

    final note = Notes(
      id: existing?.id ?? const Uuid().v4(),
      title: titleController.text.trim(),
      notes: notesController.text.trim(),
      category: category,
      createdAt: existing?.createdAt ?? DateTime.now().toUtc(),
    );

    try {
      final repo = NotesRepo.instance;

      if (existing == null) {
        await repo.create(note);
      } else {
        await repo.update(note);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the note. Try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "New Note" : "Edit Note"),
        foregroundColor: forest,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const Text(
                  "Capture a discovery",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: forest,
                  ),
                ),

                const SizedBox(height: 20), // meow
                const Text(
                  "Write down what caught your attention.",
                  style: TextStyle(color: muted, fontSize: 16),
                ),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: "What did you want to journal?",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a title";
                    }
                    if (value.trim().length > 100) {
                      return "Keep the title under 100 char's";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  autofocus: true,
                  decoration: const InputDecoration(
                    label: Text("Category"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: Categories.all.map((ct) {
                    return DropdownMenuItem(value: ct, child: Text(ct));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => category = value);
                    }
                  },
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: notesController,
                  minLines: 5,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: "Field Notes",
                    hintText: "What did you observe? Add any details",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: saveNote,
                    label: const Text("Save Note"),
                    style: FilledButton.styleFrom(
                      backgroundColor: forest,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
