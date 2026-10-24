import "package:flutter/material.dart";

import '../models/notes.dart';

import "../colors.dart";

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

  final List<String> _categories = [
    "Natures",
    "Places",
    "Landmarks",
    "Wildlife",
    "Other",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void saveNote() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        foregroundColor: forest,
      ), // im guessing having an app bar would suck tho
      body: SafeArea(
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
              const SizedBox(height: 10), // meow
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
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                initialValue: category,
                autofocus: true,
                decoration: const InputDecoration(),
                items: _categories.map((ct) {
                  return DropdownMenuItem(value: ct, child: Text(ct));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => category = value);
                  }
                },
              ),

              const SizedBox(height: 30),
              TextFormField(
                controller: _notesController,
                minLines: 5,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 30),
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
    );
  }
}
