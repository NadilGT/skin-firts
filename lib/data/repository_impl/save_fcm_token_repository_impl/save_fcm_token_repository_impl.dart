import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/save_fcm_token_model/save_fcm_token_model.dart';
import 'package:skin_firts/domain/repositories/save_fcm_token_repositoy/save_fcm_token_repositoy.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

class SaveFcmTokenRepositoryImpl extends SaveFcmTokenRepository {
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<dynamic>> saveFcmToken(
    SaveFcmTokenModel saveFcmTokenModel,
  ) async {
    try {
      final httpResponse = await apiService.saveFcmToken(saveFcmTokenModel);
      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        print(httpResponse.response);
        return DataFailed("Data Fetching Failed");
      }
    } on DioException catch (e) {
      return DataFailed(e.toString());
    }
  }
}