import 'package:flutter/material.dart';

import 'add_recipe_screen.dart';
import 'edit_recipes_list_page.dart';
import 'delete_recipe_screen.dart';

class UserRecipesPage extends StatelessWidget {
  const UserRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("User Recipes 🍲"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // ✅ Add Recipe
            recipeOption(
              context,
              "Add Recipe",
              Icons.add_circle,
              AddRecipeScreen(), // ✅ FIXED
            ),

            // ✅ Edit Recipes
            recipeOption(
              context,
              "Edit Recipes",
              Icons.edit,
              const EditRecipesListPage(),
            ),

            // ✅ Delete Recipes
            recipeOption(
              context,
              "Delete Recipes",
              Icons.delete,
              const DeleteRecipePage(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Recipe Option Card
  Widget recipeOption(
      BuildContext context,
      String title,
      IconData icon,
      Widget page,
      ) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.orange,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.orange,
          size: 18,
        ),

        // ✅ Navigation Works Perfectly
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
