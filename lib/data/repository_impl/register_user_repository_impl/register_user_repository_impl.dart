import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/register_user_model/register_user_model.dart';
import 'package:skin_firts/domain/entity/register_user_entity/register_user_entity.dart';
import 'package:skin_firts/domain/repositories/register_user_repository/register_user_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

class RegisterUserRepositoryImpl extends RegisterUserRepository {
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<RegisterUserResponseEntity>> registerPatient(
    RegisterUserModel registerUserModel,
  ) async {
    try {
      final httpResponse = await apiService.registerPatient(registerUserModel);
      if (httpResponse.response.statusCode == 201) {
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