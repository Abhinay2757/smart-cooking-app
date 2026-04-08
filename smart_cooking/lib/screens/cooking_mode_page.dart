import 'package:flutter/material.dart';

class CookingModePage extends StatefulWidget {

  final Map recipe;
  final int adults;
  final int children;

  const CookingModePage({
    super.key,
    required this.recipe,
    required this.adults,
    required this.children,
  });

  @override
  State<CookingModePage> createState() => _CookingModePageState();
}

class _CookingModePageState extends State<CookingModePage> {

  late List<bool> stepChecked;

  @override
  void initState() {
    super.initState();

    stepChecked =
        List.generate(widget.recipe["steps"].length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {

    // ✅ Total Servings Calculation
    double totalServings =
        widget.adults + (widget.children * 0.5);

    // ✅ Progress Calculation
    int completedSteps =
        stepChecked.where((s) => s == true).length;

    double progress =
        completedSteps / widget.recipe["steps"].length;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Cooking Mode 🍳"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.recipe["image"],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 15),

            // ✅ Servings Display
            Text(
              "Serving for: ${widget.adults} Adults, ${widget.children} Children",
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Ingredients With Calculation
            const Text(
              "Ingredients 🥦",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 100,
              child: ListView(
                children: widget.recipe["ingredients"]
                    .map<Widget>((item) {
                  return Text(
                    "• $item  (x$totalServings)",
                    style: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Steps With Checkbox
            const Text(
              "Steps ✅",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: widget.recipe["steps"].length,
                itemBuilder: (context, index) {

                  return CheckboxListTile(
                    value: stepChecked[index],
                    activeColor: Colors.orange,
                    checkColor: Colors.black,

                    title: Text(
                      widget.recipe["steps"][index],
                      style: const TextStyle(color: Colors.white),
                    ),

                    onChanged: (value) {
                      setState(() {
                        stepChecked[index] = value!;
                      });
                    },
                  );
                },
              ),
            ),

            // ✅ Progress Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${(progress * 100).toInt()}% Completed",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
