import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'recipe_detail_page.dart';

class MoreCategoryPage extends StatefulWidget {
  const MoreCategoryPage({super.key});

  @override
  State<MoreCategoryPage> createState() => _MoreCategoryPageState();
}

class _MoreCategoryPageState extends State<MoreCategoryPage> {
  List seasonal = [];
  List festival = [];
  List quick = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMoreRecipes();
  }

  Future<void> loadMoreRecipes() async {
    seasonal = await ApiService.getSeasonalRecipes();
    festival = await ApiService.getFestivalRecipes();
    quick = await ApiService.getQuickRecipes();

    setState(() {
      loading = false;
    });
  }

  Widget recipeList(String title, List recipes) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      children: recipes.isEmpty
          ? [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "No recipes available right now 😢",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]
          : recipes.map((r) {
        return ListTile(
          title: Text(
            r["name"],
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Cook Time: ${r["cookTime"]} min",
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward, color: Colors.orange),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: r),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("More Categories"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          recipeList("🌦 Seasonal Recipes", seasonal),
          recipeList("🎉 Festival Recipes", festival),
          recipeList("⏱ Less Time Recipes", quick),
        ],
      ),
    );
  }
}
