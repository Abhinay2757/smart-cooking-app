import 'package:flutter/material.dart';
import 'recipe_detail_page.dart';

class IngredientResultsPage extends StatelessWidget {
  final String ingredients;
  final List recipes;

  const IngredientResultsPage({
    super.key,
    required this.ingredients,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Recipes for: $ingredients"),
      ),
      body: recipes.isEmpty
          ? const Center(
        child: Text(
          "No matching recipes found 😢",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];

          return Card(
            color: Colors.grey.shade900,
            child: ListTile(
              title: Text(
                recipe["name"],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                recipe["country"],
                style: TextStyle(color: Colors.grey.shade400),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.orange),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RecipeDetailPage(recipe: recipe),
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
