import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/image_service.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // ✅ Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController cookTimeController = TextEditingController();

  bool isSaving = false;

  get _image => null;

  // ✅ Save Recipe Function
  Future<void> saveRecipe() async {
    if (nameController.text.trim().isEmpty ||
        countryController.text.trim().isEmpty ||
        ingredientsController.text.trim().isEmpty ||
        stepsController.text.trim().isEmpty ||
        cookTimeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all fields")),
      );
      return;
    }

    String? imageUrl;

    if (_image != null) {
      imageUrl = await ImageService.uploadImage(_image!);
    }

    setState(() => isSaving = true);

    // ✅ Convert Ingredients & Steps into List
    List<String> ingredients =
    ingredientsController.text.trim().split("\n");

    List<String> steps = stepsController.text.trim().split("\n");

    // ✅ Recipe Data Map
    Map<String, dynamic> recipeData = {
      "recipeId": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": nameController.text.trim(),
      "country": countryController.text.trim(),
      "image": "https://via.placeholder.com/200",
      "ingredients": ingredients,
      "steps": steps,
      "cookTime": int.parse(cookTimeController.text.trim()),
      "type": "user",
    };

    // ✅ API Call
    var result = await ApiService.addRecipe(recipeData);

    setState(() => isSaving = false);

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Recipe Added Successfully!")),
      );

      // ✅ Clear Fields
      nameController.clear();
      countryController.clear();
      ingredientsController.clear();
      stepsController.clear();
      cookTimeController.clear();

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed: ${result["message"]}")),
      );
    }
  }

  // ✅ Input Field Widget
  Widget inputField(
      String hint, TextEditingController controller, int maxLines) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade900,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("➕ Add New Recipe"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            inputField("Recipe Name 🍲", nameController, 1),
            inputField("Country (India, Italy...) 🌍", countryController, 1),
            inputField("Cook Time (minutes) ⏱", cookTimeController, 1),

            inputField(
              "Ingredients (one per line)\nExample:\nRice - 200g\nSalt - 2g",
              ingredientsController,
              5,
            ),

            inputField(
              "Steps (one per line)\nExample:\nBoil water\nAdd rice\nCook 15 min",
              stepsController,
              6,
            ),

            const SizedBox(height: 10),

            // ✅ Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: isSaving ? null : saveRecipe,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Save Recipe ✅",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
