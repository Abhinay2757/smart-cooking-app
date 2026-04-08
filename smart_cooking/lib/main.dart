import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init(); // ✅ MUST
  await Permission.notification.request();

  runApp(const SmartCookingApp());
}

class SmartCookingApp extends StatelessWidget {
  const SmartCookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
