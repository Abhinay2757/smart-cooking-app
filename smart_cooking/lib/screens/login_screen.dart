import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_cooking/screens/home_screen.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

import 'package:permission_handler/permission_handler.dart';
import 'signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ✅ Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // ✅ SEND OTP FUNCTION
  Future<void> sendOTP() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Username")),
      );
      return;
    }

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid Mobile Number")),
      );
      return;
    }

    try {
      var data = await ApiService.sendOTP(name, phone);

      if (data["success"] == true) {
        setState(() {
          otpSent = true;
        });

        await Permission.notification.request();

        if (data["demoOtp"] != null) {
          await NotificationService.showOtp(data["demoOtp"]);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error ❌ Try Again")),
      );
    }
  }

  // ✅ VERIFY OTP FUNCTION (UPDATED WITH SAVE USER INFO ✅)
  Future<void> verifyOTP() async {
    String phone = phoneController.text.trim();
    String otp = otpController.text.trim();
    String username = nameController.text.trim();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter 4-digit OTP")),
      );
      return;
    }

    try {
      var data = await ApiService.verifyOTP(phone, otp);

      if (data["success"] == true) {
        // ✅ Save Username + Mobile to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("username", username);
        await prefs.setString("mobile", phone);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Success ✅")),
        );

        // ✅ Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error ❌ Try Again")),
      );
    }
  }

  // ✅ UI BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/food_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "SMART COOKING",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ✅ Username Field
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon:
                        const Icon(Icons.person, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ✅ Mobile Field
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixText: "+91 ",
                        prefixStyle: const TextStyle(color: Colors.white),
                        prefixIcon:
                        const Icon(Icons.phone, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Send OTP Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text("Send OTP"),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Signup Button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        "New User? Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    // ✅ OTP Field After Sending OTP
                    if (otpSent) ...[
                      const SizedBox(height: 20),

                      TextField(
                        controller: otpController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Enter OTP",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                          const Icon(Icons.lock, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Verify OTP"),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
