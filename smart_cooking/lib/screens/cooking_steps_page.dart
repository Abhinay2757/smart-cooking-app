import 'package:flutter/material.dart';

class CookingStepsPage extends StatefulWidget {
  final Map recipe;

  const CookingStepsPage({
    super.key,
    required this.recipe,
  });

  @override
  State<CookingStepsPage> createState() => _CookingStepsPageState();
}

class _CookingStepsPageState extends State<CookingStepsPage> {

  late List<bool> doneSteps;
  bool isCookingCompleted = false;

  @override
  void initState() {
    super.initState();

    doneSteps = List.generate(
      widget.recipe["steps"].length,
          (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    int completed =
        doneSteps.where((step) => step).length;

    double progress =
        completed / widget.recipe["steps"].length;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Cooking Mode 🍳"),
        backgroundColor: Colors.black,
      ),

      body: isCookingCompleted
          ? _buildCompletionScreen()
          : _buildCookingUI(progress),
    );
  }

  Widget _buildCookingUI(double progress) {

    return Column(
      children: [

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.all(12),
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

        const SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: widget.recipe["steps"].length,
            itemBuilder: (context, index) {

              return CheckboxListTile(
                tileColor: Colors.grey.shade900,
                activeColor: Colors.orange,
                checkColor: Colors.black,
                value: doneSteps[index],

                title: Text(
                  widget.recipe["steps"][index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                onChanged: (value) {
                  setState(() {
                    doneSteps[index] = value!;
                  });
                },
              );
            },
          ),
        ),

        if (progress == 1.0)
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20, top: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15),
              ),
              onPressed: () {
                setState(() {
                  isCookingCompleted = true;
                });
              },
              child: const Text(
                "Cooking Completed",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [

          Icon(
            Icons.check_circle,
            color: Colors.orange,
            size: 120,
          ),

          SizedBox(height: 20),

          Text(
            "Cooking Completed",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Don't waste the food, donate the food",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}