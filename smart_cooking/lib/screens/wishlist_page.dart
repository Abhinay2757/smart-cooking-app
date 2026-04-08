import 'package:flutter/material.dart';
import '../services/wishlist_service.dart';
import 'recipe_detail_page.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List wishlist = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  // ✅ Load Saved Wishlist
  Future<void> loadWishlist() async {
    wishlist = await WishlistService.getWishlist();

    setState(() {
      loading = false;
    });
  }

  // ✅ Remove Function
  Future<void> removeRecipe(String recipeId) async {
    await WishlistService.removeFromWishlist(recipeId);
    loadWishlist();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Removed from Wishlist ❌")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Wishlist ❤️"),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : wishlist.isEmpty
          ? const Center(
        child: Text(
          "No Wishlist Recipes 😢",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final recipe = wishlist[index];

          return Card(
            color: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                recipe["name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                recipe["country"],
                style: TextStyle(color: Colors.grey.shade400),
              ),

              // ✅ Delete Icon
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeRecipe(recipe["recipeId"]),
              ),

              // ✅ Open Detail Page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
