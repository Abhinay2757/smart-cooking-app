import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_recipe_screen.dart';

class EditRecipesListPage extends StatefulWidget {
  const EditRecipesListPage({super.key});

  @override
  State<EditRecipesListPage> createState() => _EditRecipesListPageState();
}

class _EditRecipesListPageState extends State<EditRecipesListPage> {
  List recipes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  // ✅ Load Only User Recipes
  Future<void> loadRecipes() async {
    setState(() => loading = true);

    var data = await ApiService.getUserRecipes();

    setState(() {
      recipes = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Select Recipe to Edit ✏️"),
        backgroundColor: Colors.black,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())

      // ✅ Show Empty Message
          : recipes.isEmpty
          ? const Center(
        child: Text(
          "No user recipes found 😢",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )

      // ✅ Recipe List
          : RefreshIndicator(
        color: Colors.orange,
        onRefresh: loadRecipes,
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];

            return Card(
              color: Colors.grey.shade900,
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: Text(
                  recipe["name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ✅ Show cookTime also
                subtitle: Text(
                  "Cook Time: ${recipe["cookTime"] ?? "?"} min",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),

                trailing: const Icon(
                  Icons.edit,
                  color: Colors.orange,
                ),

                // ✅ Open Edit Page + Refresh After Update
                onTap: () async {
                  bool? updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditRecipePage(
                        recipe: recipe,
                      ),
                    ),
                  );

                  // ✅ Reload After Update
                  if (updated == true) {
                    loadRecipes();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
