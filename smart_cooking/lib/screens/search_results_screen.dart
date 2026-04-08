import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'recipe_detail_page.dart';
import '../services/api_service.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late String currentQuery;
  final TextEditingController searchController = TextEditingController();

  List recipes = [];
  List filteredRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    currentQuery = widget.query;
    searchController.text = currentQuery;

    loadAndSearchRecipes();
  }

  void loadAndSearchRecipes() async {
    try {
      recipes = await ApiService.getRecipes();

      filteredRecipes = recipes.where((recipe) {
        return recipe["name"]
            .toLowerCase()
            .contains(currentQuery.toLowerCase());
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("❌ Search Backend Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateSearch(String value) {
    setState(() {
      currentQuery = value.trim();

      filteredRecipes = recipes.where((recipe) {
        return recipe["name"]
            .toLowerCase()
            .contains(currentQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // ✅ HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/logo.jpg", height: 45),

                  const Text(
                    "Smart Cooking",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // ✅ FIXED PROFILE BUTTON
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person,
                        color: Colors.white, size: 30),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ✅ SEARCH BAR
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search recipes...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: updateSearch,
              ),

              const SizedBox(height: 20),

              Text(
                "Results for: \"$currentQuery\"",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ✅ RESULTS LIST
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredRecipes.isEmpty
                    ? const Center(
                  child: Text(
                    "No recipes found 😢",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];

                    return Card(
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                        title: Text(
                          recipe["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          recipe["country"],
                          style: TextStyle(
                              color: Colors.grey.shade400),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
