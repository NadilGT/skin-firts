import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/repositories/notification_repository/notification_repository.dart';
import '../../../main.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository;

  NotificationProvider(this.repository);

  String? fcmToken;

  Future<void> init() async {
    await repository.requestPermission();

    fcmToken = await repository.getFCMToken();
    print("FCM TOKEN: $fcmToken");

    repository.initListeners();

    await checkInitialMessage();

    // 🔥 Send this token to your backend API here
    // await userApi.saveFcmToken(fcmToken);

    notifyListeners();
  }

  Future<void> checkInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print("App opened from terminated state");
      final type = message.data['type'];
      print("Notification Clicked from Killed: $type");

      if (type == "APPOINTMENT_CONFIRMED") {
        // Navigate to appointment screen
        if (navigatorKey.currentContext != null) {
          print("Go to appointment details from terminated");
        }
      }
    }
  }
}
