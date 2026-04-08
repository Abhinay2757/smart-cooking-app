import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    const AndroidInitializationSettings android =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future<void> showOtp(String otp) async {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      "otp_channel",
      "OTP Notifications",
      channelDescription: "OTP Alert Channel",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      "SmartCooking OTP ✅",
      "Your OTP is: $otp",
      details,
    );
  }
}
