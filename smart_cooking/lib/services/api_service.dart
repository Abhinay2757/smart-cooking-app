import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {

  // ✅ BACKEND BASE URL
  static const String baseUrl = "http://10.109.139.146:8000";
  // ✅ AUTH ROUTES
  static const String authBaseUrl = "$baseUrl/auth";

  // ✅ RECIPE ROUTES
  static const String recipeBaseUrl = "$baseUrl/api/recipes/";

  // ================= AUTH =================

  static Future<Map<String, dynamic>> sendOTP(
      String username, String mobile) async {

    final response = await http.post(
      Uri.parse("$authBaseUrl/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "mobile": mobile,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOTP(
      String mobile, String otp) async {

    final response = await http.post(
      Uri.parse("$authBaseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mobile": mobile,
        "otp": otp,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> signup(
      String username, String mobile) async {

    final response = await http.post(
      Uri.parse("$authBaseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "mobile": mobile,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(
      String username, String mobile) async {

    final response = await http.post(
      Uri.parse("$authBaseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "mobile": mobile,
      }),
    );

    return jsonDecode(response.body);
  }

  // ================= RECIPES =================

  static Future<List<dynamic>> getRecipes() async {

    final response = await http.get(Uri.parse(recipeBaseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  static Future<List<dynamic>> getUserRecipes() async {

    final response =
    await http.get(Uri.parse("${recipeBaseUrl}user"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  static Future<Map<String, dynamic>> addRecipe(
      Map<String, dynamic> recipe) async {

    final response = await http.post(
      Uri.parse("${recipeBaseUrl}add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(recipe),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateRecipe(
      String id,
      Map<String, dynamic> updatedRecipe) async {

    final response = await http.put(
      Uri.parse("${recipeBaseUrl}update/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedRecipe),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteRecipe(
      String recipeId) async {

    final response = await http.delete(
      Uri.parse("${recipeBaseUrl}delete/$recipeId"),
    );

    return jsonDecode(response.body);
  }

  // ================= ⭐ FOOD IMAGE DETECTION (FIXED) =================

  static Future<Map<String, dynamic>> detectFoodFromImage(
      File imageFile) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/food/detect"), // ⭐ CORRECT ENDPOINT
    );

    request.files.add(
      await http.MultipartFile.fromPath("image", imageFile.path),
    );

    var response = await request.send();
    var responseData =
    await response.stream.bytesToString();

    return jsonDecode(responseData);
  }

  // ================= MORE CATEGORIES =================

  static Future<List<dynamic>> getSeasonalRecipes() async {

    final response =
    await http.get(Uri.parse("${recipeBaseUrl}more/seasonal"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  static Future<List<dynamic>> getFestivalRecipes() async {

    final response =
    await http.get(Uri.parse("${recipeBaseUrl}more/festival"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  static Future<List<dynamic>> getQuickRecipes() async {

    final response =
    await http.get(Uri.parse("${recipeBaseUrl}more/quick"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  // ================= SEARCH =================

  static Future<List<dynamic>> searchByIngredients(
      String items) async {

    final response = await http.get(
      Uri.parse("${recipeBaseUrl}search/by-ingredients?items=$items"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  static Future<List<dynamic>> searchRecipes(
      String query) async {

    final response = await http.get(
      Uri.parse("${recipeBaseUrl}search?query=$query"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["recipes"] ?? [];
    }
    return [];
  }

  // ================= TARA VOICE =================

  static Future<Map<String, dynamic>> taraVoiceCommand(
      String text) async {

    final response = await http.post(
      Uri.parse("${recipeBaseUrl}voice/command"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text}),
    );

    return jsonDecode(response.body);
  }
}
