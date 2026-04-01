abstract class NotificationRepository {
  Future<String?> getFCMToken();
  Future<void> requestPermission();
  void initListeners();
}
