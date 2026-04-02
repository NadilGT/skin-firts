import 'package:dio/dio.dart';
import 'package:skin_firts/data/models/notification_model/notification_model.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../core/storage/data_state.dart';
import '../../../domain/repositories/notification_repository/notification_repository.dart';
import '../../datasources/fcm_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FCMDataSource dataSource;
  final ApiService _apiService = sl<ApiService>();

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

  @override
  Future<DataState<NotificationPaginationResponseModel>> getNotifications(String userId, String? lastId, int limit) async {
    try{
      final httpResponse = await _apiService.getNotifications(userId, lastId, limit);
      if(httpResponse.response.statusCode == 200){
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed("Data Fetching Failed");
      }
    } on DioException catch(e) {
      return DataFailed(e.response.toString());
    }
  }

  
}
