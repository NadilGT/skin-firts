import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/repositories/doctor_repository/doctor_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

import '../../models/doctor_info_model/doctor_info_model.dart';

class DoctorsRepositoryImpl extends DoctorRepository{
  final ApiService apiService = sl<ApiService>();
  @override
  Future<DataState<List<DoctorInfoModel>>> getAllDoctors() async {
    print("repo impl");
    try{
      final httpResponse = await apiService.getAllDoctors();
      print(httpResponse);
      if (httpResponse.response.statusCode == 202) {
        return DataSuccess(httpResponse.data);
      } else {
        print(httpResponse.response);
        return DataFailed("Data Fetching Failed");
      }
      
    } on DioException catch(e) {
      return DataFailed(e.response.toString());
    }
  }

}