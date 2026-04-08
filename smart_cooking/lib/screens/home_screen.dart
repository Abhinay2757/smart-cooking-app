import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_screen.dart';
import 'search_results_screen.dart';
import 'recipe_detail_page.dart';
import 'more_category_page.dart';

import '../services/api_service.dart';
import '../services/tara_voice_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController searchController = TextEditingController();

  List recipes = [];
  List filteredRecipes = [];
  bool isLoading = true;

  String selectedCategory = "All";

  final ImagePicker picker = ImagePicker();
  final TaraVoiceService tara = TaraVoiceService();

  @override
  void initState() {
    super.initState();

    loadBackendRecipes();

    // 🔥 FIXED TARA INIT
    initTara();
  }

  // ⭐ NEW FUNCTION
  Future<void> initTara() async {
    await tara.init(); // just wait for init

    tara.start(handleTaraCommand);
  }

  @override
  void dispose() {
    tara.stop();
    super.dispose();
  }

  // ✅ LOAD RECIPES
  Future<void> loadBackendRecipes() async {
    recipes = await ApiService.getRecipes();
    filteredRecipes = recipes;

    setState(() {
      isLoading = false;
    });
  }

  // ✅ TARA COMMAND
  void handleTaraCommand(String command) {
    if (command.contains("open tiffin")) {
      filterByCategory("Tiffin");
    }
    else if (command.contains("open lunch")) {
      filterByCategory("Lunch");
    }
    else if (command.contains("open dinner")) {
      filterByCategory("Dinner");
    }
  }

  // ✅ CATEGORY FILTER
  void filterByCategory(String title) {
    setState(() {
      selectedCategory = title;

      if (title == "All") {
        filteredRecipes = recipes;
      } else {
        filteredRecipes = recipes.where((recipe) {
          String category =
          (recipe["category"] ?? "")
              .toString()
              .toLowerCase();

          return category == title.toLowerCase();
        }).toList();
      }
    });
  }

  // ✅ SEARCH
  void liveSearch(String value) {
    String query = value.toLowerCase();

    setState(() {
      filteredRecipes = recipes.where((recipe) {
        String name =
        (recipe["name"] ?? "").toLowerCase();

        return name.contains(query);
      }).toList();
    });
  }

  // 🔥 FIXED DETECT FOOD
  Future<void> detectFood(File imageFile) async {
    try {
      var result =
      await ApiService.detectFoodFromImage(imageFile);

      print("DETECTION RESULT = $result");

      String foodName =
          result["foodName"] ??
              result["food_name"] ??
              result["prediction"] ??
              result["label"] ??
              "";

      if (foodName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food not detected")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsPage(query: foodName),
        ),
      );
    } catch (e) {
      print("Detection error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error detecting food")),
      );
    }
  }

  // CAMERA
  Future<void> takePhoto() async {
    final photo =
    await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      detectFood(File(photo.path));
    }
  }

  Future<void> pickFromGallery() async {
    final image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      detectFood(File(image.path));
    }
  }

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,

      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.orange),
              title: const Text("Take Photo",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                takePhoto();
              },
            ),

            ListTile(
              leading: const Icon(Icons.image, color: Colors.orange),
              title: const Text("Add Image",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                pickFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  Widget categoryCircle(String title, String imagePath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => filterByCategory(title),

      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [

            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: AssetImage(imagePath),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: TextStyle(
                color: selectedCategory == title
                    ? Colors.orange
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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

              // 🔥 LOGO
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔥 TITLE + PROFILE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Smart Cooking",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfilePage()),
                      );
                    },
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🔥 SEARCH BAR
              TextField(
                controller: searchController,
                onChanged: liveSearch,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search recipes or ingredients...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon:
                  const Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.orange,
                      size: 30,
                    ),
                    onPressed: showImageOptions,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 CATEGORY SCROLL
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [

                    categoryCircle(
                        "Tiffin",
                        "assets/images/categories/tiffin.jpg"),

                    categoryCircle(
                        "Lunch",
                        "assets/images/categories/lunch.jpg"),

                    categoryCircle(
                        "Dinner",
                        "assets/images/categories/dinner.jpg"),

                    categoryCircle(
                      "More",
                      "assets/images/categories/more.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MoreCategoryPage()),
                        );
                      },
                    ),

                    categoryCircle(
                        "All",
                        "assets/images/categories/All.jpg"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 RECIPE LIST
              Expanded(
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe =
                    filteredRecipes[index];

                    return Card(
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(
                          bottom: 12),
                      child: ListTile(
                        title: Text(
                          recipe["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          recipe["country"],
                          style: TextStyle(
                            color:
                            Colors.grey.shade400,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailPage(
                                      recipe: recipe),
                            ),
                          );
                        },
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