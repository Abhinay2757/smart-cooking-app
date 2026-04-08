import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved language (if you implemented it)
  await LanguageManager.loadLanguage();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale _locale = Locale(LanguageManager.currentLang ?? "en");

  void changeLanguage(String code) {
    setState(() {
      _locale = Locale(code);
      LanguageManager.currentLang = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      home: const SettingsPage(),
    );
  }
}