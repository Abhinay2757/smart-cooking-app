import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import 'search_results_screen.dart';

class ImagePreviewPage extends StatefulWidget {
  final File imageFile;
  final ImageSource source;

  const ImagePreviewPage({
    super.key,
    required this.imageFile,
    required this.source,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {

  bool loading = false;
  String detectedFood = "";

  // 🔥 FIXED DETECT FUNCTION
  Future<void> detectFood() async {

    setState(() {
      loading = true;
    });

    var result =
    await ApiService.detectFoodFromImage(widget.imageFile);

    // ⭐ VERY IMPORTANT DEBUG PRINT
    print("DETECTION RESULT = $result");

    // ✅ SUPPORT MULTIPLE RESPONSE KEYS
    String food =
        result["foodName"] ??
            result["food_name"] ??
            result["prediction"] ??
            result["label"] ??
            "";

    setState(() {
      detectedFood = food;
      loading = false;
    });

    // ❌ If empty
    if(food.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Food not detected")),
      );

      return;
    }

    // ✅ OPEN RESULTS PAGE
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsPage(query: detectedFood),
      ),
    );
  }

  void retakePhoto() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Confirm Image ✅❌"),
        backgroundColor: Colors.black,
      ),

      body: Column(
        children: [

          Expanded(
            child: Image.file(widget.imageFile, fit: BoxFit.cover),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(15),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: retakePhoto,
                    child: const Text("❌ Wrong"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: detectFood,
                    child: const Text("✅ Right"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
