import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initNotifications(BuildContext context) async {
    // Request permission
    NotificationSettings settings = await _fcm.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ User granted permission");
    }

    // Get FCM Token (for sending messages from Firebase console)
    String? token = await _fcm.getToken();
    print("📱 FCM Token: $token");

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Foreground: ${message.notification?.title}");
      final snackBar = SnackBar(content: Text(message.notification?.title ?? 'New Notification'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📂 Opened App from Notification: ${message.data}");
      _handleNotificationNavigation(context, message.data);
    });
  }

  void _handleNotificationNavigation(BuildContext context, Map<String, dynamic> data) {
    // Example: Navigate to Profile if data contains userId
    if (data['route'] == 'profile') {
    //  Navigator.pushNamed(context, '/profile', arguments: data['userId']);
    context.pushNamed('profilepage',queryParameters: data['userId']);
    }
  }
}
