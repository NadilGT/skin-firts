import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class FCMDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Notification: ${message.notification?.title}");
    });
  }

  void listenClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final type = message.data['type'];
      print("Notification Clicked: $type");

      if (type == "APPOINTMENT_CONFIRMED") {
        // Navigate to appointment screen
        if (navigatorKey.currentContext != null) {
          // Assuming AppointmentScreen is the target. We navigate to a generic placeholder or actual screen.
          print("Go to appointment details");
          // navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const AppointmentScreen()));
        }
      }
    });
  }
}
