import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

import '../models/notes.dart';
import "../colors.dart";
import "../data/notes_repo.dart"; // ughhh dart being a ; language trips me up sometimes, its like i spent 1 hour just putting semicolons
import "../models/category.dart";

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  String category = "Nature";

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final note = Notes(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      category: category,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      await NotesRepo.instance.create(note);

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
        title: const Text("New Note"),
        foregroundColor: forest,
      ), // im guessing having an app bar would suck tho
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Form(
            key: _formKey,
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
                  controller: _titleController,
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
                  controller: _notesController,
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
