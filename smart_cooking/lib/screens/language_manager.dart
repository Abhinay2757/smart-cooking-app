import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static String currentLang = "en";

  static Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLang = prefs.getString("app_lang") ?? "en";
  }

  static Future<void> saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("app_lang", lang);
    currentLang = lang;
  }
}