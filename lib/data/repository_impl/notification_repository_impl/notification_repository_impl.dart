import '../../../domain/repositories/notification_repository/notification_repository.dart';
import '../../datasources/fcm_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FCMDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Future<String?> getFCMToken() {
    return dataSource.getToken();
  }

  @override
  Future<void> requestPermission() {
    return dataSource.requestPermission();
  }

  @override
  void initListeners() {
    dataSource.listenForeground();
    dataSource.listenClick();
  }
}
