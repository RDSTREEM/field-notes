import "package:field_notes/models/notes.dart";
import "package:flutter/material.dart";

import "../colors.dart";
import "add_screen.dart";
import "../widgets/note_card.dart";

// Gosh i had forgotten how annoying flutter was lol
//

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Notes> notes = [];

  Future<void> addNote() async {
    final note = await Navigator.push<Notes>(
      context,
      MaterialPageRoute(builder: (_) => AddScreen()),
    );

    if (!mounted || note == null) return;

    setState(() {
      notes.insert(0, note);
    });
  }

  String get today {
    final now = DateTime.now();

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

    const weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of the body of the home page
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: forest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.explore_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FIELD NOTES',
                              style: TextStyle(
                                color: forest,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "Your personal field journal",
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.wb_sunny_outlined, color: forest, size: 25),
                      ],
                    ),
                    const SizedBox(height: 42),
                    Text(
                      today,
                      style: TextStyle(
                        color: muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Notice more.\nRemember Everything.",
                      style: TextStyle(
                        color: forest,
                        fontSize: 32,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "A little place for the things you discover out there.",
                      style: TextStyle(color: muted, fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8E5DA)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            color: forest,
                            size: 30,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your field journal",
                                  style: TextStyle(
                                    color: forest,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${notes.length} "
                                  "${notes.length == 1 ? "observation" : "observations"}",
                                  style: TextStyle(color: muted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 88),

                    if (notes.isEmpty)
                      emptyState()
                    else ...[
                      const Text(
                        "RECENT DISCOVERIES",
                        style: TextStyle(
                          color: muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...notes.map((note) => noteCard(note)),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: addNote,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Record an observation",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: forest,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget emptyState() {
  return Padding(
    padding: EdgeInsetsGeometry.symmetric(vertical: 24),
    child: Column(
      children: [
        Center(
          child: Icon(
            Icons.nature_outlined,
            size: 54,
            color: forest.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            "The world is full of little wonder.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: forest,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            "Your first discovery is waiting to be recorded.",
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 13, height: 15),
          ),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}
