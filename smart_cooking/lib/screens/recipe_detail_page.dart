import 'package:flutter/material.dart';
import 'serving_input_page.dart';
import '../services/wishlist_service.dart';
import 'dart:io'; // ✅ IMPORTANT

class RecipeDetailPage extends StatefulWidget {
  final Map recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    checkWishlist();
  }

  Future<void> checkWishlist() async {
    bool saved =
    await WishlistService.isWishlisted(widget.recipe["recipeId"]);

    setState(() {
      isWishlisted = saved;
    });
  }

  Future<void> toggleWishlist() async {
    String recipeId = widget.recipe["recipeId"];

    if (isWishlisted) {
      await WishlistService.removeFromWishlist(recipeId);
    } else {
      await WishlistService.addToWishlist(widget.recipe);
    }

    setState(() {
      isWishlisted = !isWishlisted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isWishlisted
              ? "Added to Wishlist ❤️"
              : "Removed from Wishlist ❌",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.recipe["name"] ?? "No Name";
    String country = widget.recipe["country"] ?? "Unknown";

    // ✅ FIXED: no forced network placeholder
    String image = widget.recipe["image"] ?? "";

    List ingredients = widget.recipe["ingredients"] ?? [];
    List steps = widget.recipe["steps"] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 28,
            ),
            onPressed: toggleWishlist,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 IMAGE + NAME SECTION
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: image.isEmpty
                      ? Container(
                    height: 110,
                    width: 110,
                    color: Colors.grey.shade800,
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 40,
                    ),
                  )
                      : image.startsWith("http")
                      ? Image.network(
                    image,
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        height: 110,
                        width: 110,
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                        ),
                      );
                    },
                  )
                      : Image.file(
                    File(image),
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        country,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Ingredients 🥦",
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ingredients.isEmpty
                  ? const Center(
                child: Text(
                  "No Ingredients Available 😢",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "• ${ingredients[index]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            if (steps.isNotEmpty) ...[
              const Text(
                "Steps 👨‍🍳",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 6),
                      child: Text(
                        "${index + 1}. ${steps[index]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Cook Now 🍲",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ServingInputPage(recipe: widget.recipe),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}