import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class EditRecipePage extends StatefulWidget {
  final Map recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController nameController;
  late TextEditingController countryController;
  late TextEditingController ingredientsController;
  late TextEditingController stepsController;
  late TextEditingController cookTimeController;

  File? selectedImage;
  String? imageBase64;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.recipe["name"]);

    countryController =
        TextEditingController(text: widget.recipe["country"]);

    ingredientsController = TextEditingController(
      text: widget.recipe["ingredients"].join("\n"),
    );

    stepsController = TextEditingController(
      text: widget.recipe["steps"].join("\n"),
    );

    cookTimeController = TextEditingController(
      text: widget.recipe["cookTime"]?.toString() ?? "10",
    );
  }

  // ✅ Pick Image From Gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage = File(picked.path);

      // ✅ Convert image to base64
      final bytes = await selectedImage!.readAsBytes();
      imageBase64 = base64Encode(bytes);

      setState(() {});
    }
  }

  // ✅ UPDATE RECIPE FUNCTION
  Future<void> updateRecipe() async {
    Map<String, dynamic> updatedRecipe = {
      "recipeId": widget.recipe["recipeId"],

      "name": nameController.text.trim(),
      "country": countryController.text.trim(),

      "cookTime": int.tryParse(cookTimeController.text) ?? 10,

      // ✅ Store image (if updated)
      "image": imageBase64 ?? widget.recipe["image"],

      "ingredients": ingredientsController.text
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),

      "steps": stepsController.text
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),

      "type": "user",
    };

    var result = await ApiService.updateRecipe(
      widget.recipe["recipeId"],
      updatedRecipe,
    );

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Recipe Updated Successfully!")),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Update Failed: ${result["message"]}")),
      );
    }
  }

  // ✅ Input Field UI
  Widget inputBox(
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade900,
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
        title: const Text("Edit Recipe ✏️"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            inputBox("Recipe Name", nameController),

            inputBox("Country", countryController),

            inputBox(
              "Cook Time (minutes)",
              cookTimeController,
              keyboard: TextInputType.number,
            ),

            // ✅ IMAGE PICKER
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 160,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                    : Center(
                  child: Text(
                    "Tap to Change Image 📸",
                    style: TextStyle(
                        color: Colors.orange.shade300,
                        fontSize: 16),
                  ),
                ),
              ),
            ),

            inputBox(
              "Ingredients (One per line)",
              ingredientsController,
              maxLines: 5,
            ),

            inputBox(
              "Steps (One step per line)",
              stepsController,
              maxLines: 6,
            ),

            const SizedBox(height: 15),

            // ✅ Update Button
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
                onPressed: updateRecipe,
                child: const Text(
                  "Update Recipe ✅",
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
