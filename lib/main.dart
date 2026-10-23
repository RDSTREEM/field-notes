import 'package:flutter/material.dart';

import "./screens/home_screen.dart";

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
      // theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomeScreen(),
      theme: ThemeData(fontFamily: "Roboto"),
    );
  }
}
