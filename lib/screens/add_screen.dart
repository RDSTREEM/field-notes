import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:geolocator/geolocator.dart';

import '../models/notes.dart';
import '../data/notes_repo.dart';
import '../models/category.dart';

class AddScreen extends StatefulWidget {
  final Notes? note;

  const AddScreen({super.key, this.note});

  @override
  State<AddScreen> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  late String category;

  String? path;
  double? latitude;
  double? longitude;
  bool loc = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();

    final note = widget.note;
    titleController.text = note?.title ?? '';
    notesController.text = note?.notes ?? '';
    category = note?.category ?? 'Nature';
    path = note?.imagePath;
    latitude = note?.latitude;
    longitude = note?.longitude;
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> pick(ImageSource source) async {
    try {
      final picked = await imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxHeight: 2000,
      );

      if (picked == null || !mounted) return;

      final dir = await getApplicationSupportDirectory();
      final photosDir = Directory(p.join(dir.path, 'photos'));
      await photosDir.create(recursive: true);

      final ext = p.extension(picked.path);
      final dest = p.join(photosDir.path, '${const Uuid().v4()}$ext');
      await File(picked.path).copy(dest);

      if (!mounted) return;
      setState(() => path = dest);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not attach this photo')),
      );
    }
  }

  Future<void> location() async {
    setState(() => loc = true);

    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw Exception('Enable location services first');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission not granted');
      }

      final position = await Geolocator.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => loc = false);
    }
  }

  Future<void> saveNote() async {
    if (saving || !formKey.currentState!.validate()) return;

    setState(() => saving = true);

    final existing = widget.note;
    final note = Notes(
      id: existing?.id ?? const Uuid().v4(),
      title: titleController.text.trim(),
      notes: notesController.text.trim(),
      category: category,
      createdAt: existing?.createdAt ?? DateTime.now().toUtc(),
      imagePath: path,
      latitude: latitude,
      longitude: longitude,
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
    } catch (_) {
      if (!mounted) return;

      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the note. Try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Text(
                  'Capture a discovery',
                  style: textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Write down what caught your attention.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'What did you want to journal?',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.trim().length > 100) {
                      return 'Keep the title under 100 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
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
                    labelText: 'Field Notes',
                    hintText: 'What did you observe? Add any details',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Attachments',
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (path != null && File(path!).existsSync()) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(path!),
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => pick(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Take photo'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Choose photo'),
                    ),
                    if (path != null)
                      TextButton.icon(
                        onPressed: () => setState(() => path = null),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Remove photo'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: loc ? null : location,
                  icon: loc
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    loc
                        ? 'Getting location...'
                        : latitude == null
                        ? 'Add current location'
                        : 'Update location',
                  ),
                ),
                if (latitude != null && longitude != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${latitude!.toStringAsFixed(5)}, '
                    '${longitude!.toStringAsFixed(5)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        latitude = null;
                        longitude = null;
                      });
                    },
                    child: const Text('Remove location'),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: saving ? null : saveNote,
                    icon: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(saving ? 'Saving...' : 'Save Note'),
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
