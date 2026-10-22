import 'package:flutter/material.dart';

void main() {
  runApp(const FieldNotesApp());
}

// Color pallete
const forest = Color(0xFF244C3A); // primary color
const paper = Color(0xFFF7E5EE); // secondary color
const muted = Color(0xFF77796F);

class FieldNotesApp extends StatelessWidget {
  const FieldNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomeScreen(),
    );
  }
}

// Gosh i had forgotten how annoying flutter was lol
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // start of the body of the home page
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            // it is going to be made up of columns
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // which have the following rows
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: forest,
                      borderRadius: BorderRadius.circular(20),
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
                      Text('Field Notes', style: TextStyle(color: forest)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
