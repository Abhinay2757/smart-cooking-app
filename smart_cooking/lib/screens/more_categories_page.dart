import 'package:flutter/material.dart';

class MoreCategoriesPage extends StatelessWidget {
  const MoreCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("More Categories"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            categoryTile(context, "🌦 Seasons Recipes"),
            categoryTile(context, "🎉 Festival Recipes"),
            categoryTile(context, "⚡ Less Time Recipes"),
          ],
        ),
      ),
    );
  }

  Widget categoryTile(BuildContext context, String title) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.orange),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title Coming Soon ✅")),
          );
        },
      ),
    );
  }
}
