import 'package:flutter/material.dart';

import '../models/notes.dart';
import '../screens/details_screen.dart';
import '../widgets/note_card.dart';
import '../data/notes_repo.dart';
import '../models/category.dart';
import 'add_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Notes> notes = [];
  bool loading = true;
  String? loadErr;

  final searchController = TextEditingController();

  String q = '';
  String? cat;
  bool asc = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String get today {
    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return '${weekdays[now.weekday - 1]}, '
        '${months[now.month - 1]} ${now.day}';
  }

  Future<void> addNote() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddScreen()),
    );

    if (!mounted) return;
    if (saved == true) await filter();
  }

  Future<void> loadNotes() async {
    try {
      final data = await NotesRepo.instance.getAll();

      if (!mounted) return;

      setState(() {
        notes = data;
        loading = false;
        loadErr = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
        loadErr = 'Could not load the notes';
      });
    }
  }

  Future<void> openNote(Notes note) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetailsScreen(note: note)),
    );

    if (!mounted) return;
    await filter();
  }

  Future<void> filter() async {
    setState(() => loading = true);

    try {
      final results = await NotesRepo.instance.search(
        query: q,
        category: cat,
        des: asc,
      );

      if (!mounted) return;

      setState(() {
        notes = results;
        loading = false;
        loadErr = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
        loadErr = 'Could not search';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.explore_outlined,
                      color: colors.onPrimary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FIELD NOTES',
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'Your personal field journal',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.65),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onToggleTheme,
                    tooltip: isDark
                        ? 'Switch to light mode'
                        : 'Switch to dark mode',
                    icon: Icon(
                      Icons.wb_sunny_outlined,
                      color: colors.onSurface,
                      size: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 42),
              Text(
                today,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Notice more.\nRemember Everything.',
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 32,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'A little place for the things you discover out there.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.75),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  q = value;
                  filter();
                },
                decoration: InputDecoration(
                  hintText: 'Search your discoveries...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: q.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            searchController.clear();
                            q = '';
                            filter();
                          },
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      initialValue: cat,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All categories'),
                        ),
                        ...Categories.all.map(
                          (category) => DropdownMenuItem<String?>(
                            value: category,
                            child: Text(category),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        cat = value;
                        filter();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    tooltip: asc ? 'Newest first' : 'Oldest first',
                    onPressed: () {
                      asc = !asc;
                      filter();
                    },
                    icon: Icon(
                      asc ? Icons.south_rounded : Icons.north_rounded,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        color: colors.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your field journal',
                              style: textTheme.titleMedium?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${notes.length} '
                              '${notes.length == 1 ? 'observation' : 'observations'}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (loadErr != null)
                Column(
                  children: [
                    Text(loadErr!),
                    TextButton(
                      onPressed: loadNotes,
                      child: const Text('Try again'),
                    ),
                  ],
                )
              else if (notes.isEmpty)
                emptyState(f: q.trim().isNotEmpty || cat != null)
              else ...[
                Text(
                  'RECENT DISCOVERIES',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...notes.map(
                  (note) => NoteCard(note: note, tap: () => openNote(note)),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: addNote,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Record an observation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyState({bool f = false}) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.nature_outlined,
            size: 54,
            color: colors.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            f
                ? 'No matching discoveries'
                : 'The world is full of little wonder.',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            f
                ? 'Try another search or clear your filters.'
                : 'Your first discovery is waiting to be recorded.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          if (f) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                searchController.clear();
                q = '';
                cat = null;
                filter();
              },
              label: const Text('Clear Filters'),
              icon: const Icon(Icons.clear),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
