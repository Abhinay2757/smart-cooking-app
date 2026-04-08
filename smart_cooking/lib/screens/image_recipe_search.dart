import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_preview_page.dart';

class ImageRecipeSearchPage extends StatefulWidget {
  const ImageRecipeSearchPage({super.key});

  @override
  State<ImageRecipeSearchPage> createState() =>
      _ImageRecipeSearchPageState();
}

class _ImageRecipeSearchPageState extends State<ImageRecipeSearchPage> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  // ✅ Show Bottom Sheet Options
  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.orange),
              title: const Text(
                "Add Photo (Gallery)",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.orange),
              title: const Text(
                "Take Photo (Camera)",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  // ✅ Pick Image From Source
  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      selectedImage = File(image.path);

      // ✅ Open Preview Page (Right / Wrong)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImagePreviewPage(
            imageFile: selectedImage!,
            source: source,
          ),
        ),
      );
    }
  }

  // ✅ UI Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Image Recipe Search 📷🍲"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.all(15),
          ),
          onPressed: showImageOptions,
          child: const Text(
            "Upload Food Image ➕",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
