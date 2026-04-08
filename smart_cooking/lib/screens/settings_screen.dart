import 'dart:ui';
import 'package:flutter/material.dart';
import 'main.dart';
import 'translations.dart';
import 'language_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String aiGender = "Tara";
  String selectedLanguage = "English";
  double volume = 50;

  final List<String> languages = [
    "English",
    "Telugu",
    "Hindi",
    "Tamil",
    "Kannada",
    "Malayalam",
    "French",
    "Spanish",
    "German",
    "Japanese",
    "Chinese",
    "Arabic",
    "Russian"
  ];

  Map<String, String> languageCodes = {
    "English": "en",
    "Telugu": "te",
    "Hindi": "hi",
    "Tamil": "ta",
    "Kannada": "kn",
    "Malayalam": "ml",
    "French": "fr",
    "Spanish": "es",
    "German": "de",
    "Japanese": "ja",
    "Chinese": "zh",
    "Arabic": "ar",
    "Russian": "ru",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    translations[LanguageManager.currentLang]?["settings"] ?? "Settings",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// AI GENDER
              glassCard(
                title: translations[LanguageManager.currentLang]?["ai_gender"] ?? "AI Gender",
                child: DropdownButton<String>(
                  value: aiGender,
                  dropdownColor: Colors.grey.shade900,
                  iconEnabledColor: Colors.orange,
                  style: const TextStyle(color: Colors.white),

                  items: ["Tara", "Tejas"]
                      .map((g) => DropdownMenuItem(
                    value: g,
                    child: Text(g),
                  ))
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      aiGender = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// LANGUAGE
              glassCard(
                title: translations[LanguageManager.currentLang]?["language"] ?? "App Language",
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: Colors.grey.shade900,
                  iconEnabledColor: Colors.orange,
                  style: const TextStyle(color: Colors.white),

                  items: languages
                      .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  ))
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// VOLUME
              glassCard(
                title: translations[LanguageManager.currentLang]?["volume"] ?? "Volume",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      activeColor: Colors.orange,
                      inactiveColor: Colors.grey,
                      label: "${volume.toInt()}%",

                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });
                      },
                    ),

                    Text(
                      "Volume: ${volume.toInt()}%",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  onPressed: () {

                    String langCode =
                        languageCodes[selectedLanguage] ?? "en";

                    // update language manager
                    LanguageManager.currentLang = langCode;

                    // rebuild whole app
                    MyApp.of(context)?.changeLanguage(langCode);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Language changed to $selectedLanguage"),
                      ),
                    );
                  },

                  child: Text(
                      translations[LanguageManager.currentLang]?["save"] ?? "Save Settings",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// GLASS CARD
  Widget glassCard({required String title, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              child,
            ],
          ),
        ),
      ),
    );
  }
}