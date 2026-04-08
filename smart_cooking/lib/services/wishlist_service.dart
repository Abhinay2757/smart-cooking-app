import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static const String key = "wishlist_recipes";

  // ✅ Get Wishlist Recipes
  static Future<List<Map<String, dynamic>>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString(key);

    if (data == null) return [];

    List decoded = jsonDecode(data);

    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ✅ Add Recipe to Wishlist
  static Future<void> addToWishlist(Map recipe) async {
    final prefs = await SharedPreferences.getInstance();

    List current = await getWishlist();

    // ✅ Avoid duplicates
    bool alreadyExists =
    current.any((r) => r["recipeId"] == recipe["recipeId"]);

    if (!alreadyExists) {
      current.add(Map<String, dynamic>.from(recipe));
    }

    prefs.setString(key, jsonEncode(current));
  }

  // ✅ Remove Recipe from Wishlist
  static Future<void> removeFromWishlist(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();

    List current = await getWishlist();

    current.removeWhere((r) => r["recipeId"] == recipeId);

    prefs.setString(key, jsonEncode(current));
  }

  // ✅ Check if Recipe Wishlisted
  static Future<bool> isWishlisted(String recipeId) async {
    List current = await getWishlist();
    return current.any((r) => r["recipeId"] == recipeId);
  }
}
