import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../core/services/local_notification_service.dart';
import '../../presentation/pages/calender/calender_page.dart';

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

      if (message.notification != null) {
        LocalNotificationService.showNotification(
          title: message.notification!.title ?? "New Notification",
          body: message.notification!.body ?? "",
          payload: message.data['type'],
        );
      }
    });
  }

  void listenClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final type = message.data['type'];
      print("Notification Clicked: $type");

      // Navigate to Calendar Page
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarPage()),
        );
      }
    });
  }
}
