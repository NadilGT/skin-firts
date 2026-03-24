import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/find_role_model/find_role_model.dart';
import 'package:skin_firts/domain/repositories/find_role_repository/find_role_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

class FindRoleRepositoryImpl extends FindRoleRepository {
  final ApiService _apiService = sl<ApiService>();

  @override
  Future<DataState<FindRoleResponseModel>> findRole(String firebaseUid) async {
    try {
      final httpResponse = await _apiService.findRole(firebaseUid);
      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed('Unable to verify your account. Please try again.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return DataFailed('Account not found. Please sign up first.');
      }
      return DataFailed('A network error occurred. Please check your connection.');
    } catch (e) {
      return DataFailed('Something went wrong. Please try again.');
    }
  }
}