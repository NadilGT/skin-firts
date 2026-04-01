import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/repositories/notification_repository/notification_repository.dart';
import '../../../main.dart';
import '../../domain/usecases/save_fcm_token_usecase/save_fcm_token_usecase.dart';
import '../../data/models/save_fcm_token_model/save_fcm_token_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skin_firts/core/storage/data_state.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository;
  final SaveFcmTokenUseCase saveFcmTokenUseCase;

  NotificationProvider(this.repository, this.saveFcmTokenUseCase);

  String? fcmToken;

  Future<void> init() async {
    await repository.requestPermission();

    fcmToken = await repository.getFCMToken();
    print("FCM TOKEN: $fcmToken");

    repository.initListeners();

    await checkInitialMessage();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && userId.isNotEmpty && fcmToken != null) {
      final dataState = await saveFcmTokenUseCase.call(
        params: SaveFcmTokenModel(userId: userId, fcmToken: fcmToken!),
      );
      if (dataState is DataSuccess) {
        print("✅ FCM Token successfully sent to backend");
      } else if (dataState is DataFailed) {
        print("❌ Failed to send FCM token to backend: ${dataState.error}");
      }
    } else {
      print("⚠️ Local user not logged in, could not send FCM to backend");
    }

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
