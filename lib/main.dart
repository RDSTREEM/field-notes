import "package:field_notes/theme/app_theme.dart";
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

import "./screens/home_screen.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FieldNotesApp());
}

class FieldNotesApp extends StatefulWidget {
  const FieldNotesApp({super.key});

  @override
  State<FieldNotesApp> createState() => FieldNotesAppState();
}

class FieldNotesAppState extends State<FieldNotesApp> {
  static const key = "fieldnotes_dark_mode";

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      isDark = prefs.getBool(key) ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final next = !isDark;
    setState(() {
      isDark = next;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onToggleTheme: toggleTheme),
    );
  }
}
