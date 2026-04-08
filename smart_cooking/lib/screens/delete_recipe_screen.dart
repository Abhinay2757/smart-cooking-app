import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DeleteRecipePage extends StatefulWidget {
  const DeleteRecipePage({super.key});

  @override
  State<DeleteRecipePage> createState() => _DeleteRecipePageState();
}

class _DeleteRecipePageState extends State<DeleteRecipePage> {

  List recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  // ✅ Fetch Recipes from Backend
  Future<void> fetchRecipes() async {
    recipes = await ApiService.getUserRecipes();

    setState(() {
      isLoading = false;
    });
  }

  // ✅ Delete Recipe Function
  Future<void> deleteRecipe(String recipeId) async {

    // ✅ Confirmation Dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Recipe?"),
        content: const Text("Are you sure you want to delete this recipe?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == false) return;

    // ✅ Call Backend Delete API
    await ApiService.deleteRecipe(recipeId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Recipe Deleted Successfully")),
    );

    // ✅ Refresh List
    fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Delete Recipes 🗑️"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : recipes.isEmpty
          ? const Center(
        child: Text(
          "No Recipes Found ❌",
          style: TextStyle(color: Colors.white),
        ),
      )

          : ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {

          final recipe = recipes[index];

          return Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.all(10),

            child: ListTile(

              leading: const Icon(
                Icons.restaurant_menu,
                color: Colors.orange,
              ),

              title: Text(
                recipe["name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),

              subtitle: Text(
                recipe["country"],
                style: const TextStyle(color: Colors.grey),
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),

                onPressed: () {
                  deleteRecipe(recipe["recipeId"]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
