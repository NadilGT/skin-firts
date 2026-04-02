import '../../../core/storage/data_state.dart';
import '../../../data/models/notification_model/notification_model.dart';

abstract class NotificationRepository {
  Future<String?> getFCMToken();
  Future<void> requestPermission();
  void initListeners();
  
  Future<DataState<NotificationPaginationResponseModel>> getNotifications(
    String userId,
    String? lastId,
    int limit,
  );
}
