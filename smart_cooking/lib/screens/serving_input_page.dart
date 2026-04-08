import 'package:flutter/material.dart';
import 'cooking_mode_page.dart';

class ServingInputPage extends StatefulWidget {

  final Map recipe;
  const ServingInputPage({super.key, required this.recipe});

  @override
  State<ServingInputPage> createState() => _ServingInputPageState();
}

class _ServingInputPageState extends State<ServingInputPage> {

  TextEditingController adultsController = TextEditingController(text: "1");
  TextEditingController childrenController = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.recipe["name"]),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              "Enter Number of People 👨‍👩‍👧",
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Adults Input
            TextField(
              controller: adultsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Adults",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Children Input
            TextField(
              controller: childrenController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Children",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ✅ Start Cooking Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                child: const Text(
                  "Start Cooking 🍲",
                  style: TextStyle(fontSize: 18),
                ),

                onPressed: () {

                  int adults = int.parse(adultsController.text);
                  int children = int.parse(childrenController.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CookingModePage(
                        recipe: widget.recipe,
                        adults: adults,
                        children: children,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
