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
              // hurray managed to remove that weird ruler thingi that came with the flutter extension
              // and the tooling is awesome fr
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
                      Text(
                        'Field Notes',
                        style: TextStyle(
                          color: forest,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Your personal field journal",
                        style: TextStyle(
                          color: muted,
                          fontSize: 15,
                          letterSpacing: 2,
                        ), // random values, will c how they work on phone later
                      ), // or smt i am not good at copyright
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.wb_sunny_outlined, color: forest, size: 25),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                "Thursday, October 22",
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ), // Todo: how the guacamole u get the date in flutter / dart?
              const SizedBox(height: 12),
              const Text(
                "Notice more.\n Remember Everything.",
                style: TextStyle(
                  color: forest,
                  fontSize: 32,
                  height: 2,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
