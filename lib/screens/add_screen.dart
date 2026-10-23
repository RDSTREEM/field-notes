import "package:flutter/material.dart";

import '../models/notes.dart';

const forest = Color(0xFF244C3A); // primary color
const paper = Color(0xFFF7E5EE); // secondary color
const muted = Color(0xFF77796F);

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
    return Scaffold();
  }
}
