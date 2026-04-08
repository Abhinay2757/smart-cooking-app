import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wishlist_page.dart';
import 'settings_screen.dart';
import 'contact_screen.dart';
import 'login_screen.dart';
import 'user_recipes_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Loading...";
  String mobile = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // ✅ Load Username & Mobile From SharedPreferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("username") ?? "Guest";
      mobile = prefs.getString("mobile") ?? "";
    });
  }

  // ✅ Logout Clears Data
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔙 Back + Title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ✅ Profile Card
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.person,
                              size: 50, color: Colors.black),
                        ),
                        const SizedBox(height: 15),

                        // ✅ Username From Login
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // ✅ Mobile From Login
                        Text(
                          mobile.isEmpty ? "No Mobile" : "+91 $mobile",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Options
              profileOption(Icons.favorite, "Wishlist"),
              profileOption(Icons.check_circle, "Completed Recipes"),
              profileOption(Icons.restaurant_menu, "User Recipes"),

              const SizedBox(height: 25),

              profileOption(Icons.settings, "Settings"),
              profileOption(Icons.support_agent, "Contact Us & Feedback"),
              profileOption(Icons.logout, "Logout"),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Profile Option Tile
  Widget profileOption(IconData icon, String title) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.white),

        onTap: () {
          if (title == "Wishlist") {
            Navigator.push(
              context,
              animatedRoute(const WishlistPage()),
            );
          }

            else if (title == "Settings") {
            Navigator.push(context, animatedRoute(const SettingsPage()));
          } else if (title == "Contact Us & Feedback") {
            Navigator.push(context, animatedRoute(const ContactPage()));
          } else if (title == "User Recipes") {
            Navigator.push(context, animatedRoute(const UserRecipesPage()));
          } else if (title == "Logout") {
            logoutUser(); // ✅ Clear saved login data
          }
        },
      ),
    );
  }

  // ✅ Animation Route
  PageRouteBuilder animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}
